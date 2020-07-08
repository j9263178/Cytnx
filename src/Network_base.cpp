#include <typeinfo>
#include "Network.hpp"
#include "utils/utils_internal_interface.hpp"
#include "linalg.hpp"

using namespace std;

namespace cytnx{
    void Network_base::Fromfile(const std::string &fname){
        cytnx_error_msg(true,"[ERROR][Network][Fromfile] call from uninitialize network.%s","\n");
    }
    void Network_base::Savefile(const std::string &fname){
        cytnx_error_msg(true,"[ERROR][Network][Savefile] call from uninitialize network.%s","\n");
    }
    void Network_base::PutCyTensor(const std::string &name, const CyTensor &utensor, const bool &is_clone){
        cytnx_error_msg(true,"[ERROR][Network][PutCyTensor] call from uninitialize network.%s","\n");
    }
    void Network_base::PutCyTensor(const cytnx_uint64 &idx, const CyTensor &utensor, const bool &is_clone){
        cytnx_error_msg(true,"[ERROR][Network][PutCyTensor] call from uninitialize network.%s","\n");
    }
    void Network_base::PutCyTensors(const std::vector<string> &names, const std::vector<CyTensor> &utensors, const bool &is_clone){
        cytnx_error_msg(true,"[ERROR][Network][PutCyTensors] call from uninitialize network.%s","\n");
    }
    void Network_base::clear(){
        cytnx_error_msg(true,"[ERROR][Network][Clear] call from uninitialize network.%s","\n");
    }
    CyTensor Network_base::Launch(const bool &optimal){
        cytnx_error_msg(true,"[ERROR][Network][Launch] call from uninitialize network.%s","\n");
        return CyTensor();
    }
    boost::intrusive_ptr<Network_base> Network_base::clone(){
        cytnx_error_msg(true,"[ERROR][Network][clone] call from uninitialize network. %s","\n");
        return nullptr;
    }
    void Network_base::PrintNet(std::ostream& os){
        os << "        [Empty Network]" << endl;
        os << "--- Please Load Network file ---\n" ;
        os << endl;
    }

}//namespace cytnx
