
#include <prim/prim.h>
#include "../../Synfull/src/netstream/messages.h"



namespace Synfull_App {

	class MsgTime
	{
	public:
		MsgTime(InjectReqMsg* msg, u64 time);
		~MsgTime();
		InjectReqMsg* getMsg();
		u64 getTime();
		void setTime(u32 new_val);

	private:
		InjectReqMsg* _msg;
		u64 _time;

	};

}