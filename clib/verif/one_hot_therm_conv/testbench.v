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
    #(parameter width = 8,
      parameter initial_seed = 0)
   ();
   
   reg [0:width-1] data_in;
   wire [0:width-1] data_out;
   
   c_one_hot_therm_conv
     #(.width(width))
   dut
     (.data_in(data_in),
      .data_out(data_out));
   
   integer 	    test;
   integer 	    i;
   
   reg [0:width-1]  data_ref;
   
   initial
     begin
	
	for(test = 0; test < width; test = test + 1)
	  begin
	     data_in = {width{1'b0}};
	     data_in[test] = 1'b1;
	     data_ref = data_in;
	     for(i = test + 1; i < width; i = i + 1)
	       data_ref[i] = 1'b1;
	     #1;
	     if(data_out != data_ref)
	       $display("ERROR: in=%b, out=%b, expected=%b",
			data_in, data_out, data_ref);
	     else
	       $display("OK:    in=%b, out=%b", data_in, data_out);
	     #1;
	  end
	
	$finish;
	
     end
   
endmodule
