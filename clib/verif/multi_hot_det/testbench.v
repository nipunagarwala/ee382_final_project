// $Id: testbench.v 5188 2012-08-30 00:31:31Z dub $

/*
 Copyright (c) 2007-2012, Trustees of The Leland Stanford Junior University
 All rights reserved.

 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions are met:

 Redistributions of source code must retain the above copyright notice, this 
 list of conditions and the following disclaimer.
 Redistributions in binary form must reproduce the above copyright notice, this
 list of conditions and the following disclaimer in the documentation and/or
 other materials provided with the distribution.

 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE 
 DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
 ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
 ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

`default_nettype none

module testbench
   ();
   
`include "c_constants.v"
`include "c_functions.v"
   
   parameter width = 5;
   
   parameter Tclk = 2;
   
   localparam cnt_width = clogb(width+1);
   
   reg [0:width-1] data;
   
   wire 	   dut_multi_hot;
   c_multi_hot_det
     #(.width(width))
   dut
     (.data(data),
      .multi_hot(dut_multi_hot));
   
   wire [0:cnt_width-1] count;
   c_add_nto1
     #(.width(1),
       .num_ports(width))
   adder
     (.data_in(data),
      .data_out(count));
   
   wire 		ref_multi_hot;
   assign ref_multi_hot = (count > 1);
   
   wire 		error;
   assign error = ref_multi_hot ^ dut_multi_hot;
   
   reg 			clk;
   
   always
   begin
      clk <= 1'b1;
      #(Tclk/2);
      clk <= 1'b0;
      #(Tclk/2);
   end
   
   integer i;
   
   initial
   begin
      
      for(i = 0; i < (1 << width); i = i + 1)
	begin
	   
	   @(posedge clk);
	   data = i;
	   
	   @(negedge clk);
	   if(error)
	     begin
		$display("error detected for data=%x!", data);
		$stop;
	     end
	   
	end
      
      $finish;
      
   end
   
endmodule
