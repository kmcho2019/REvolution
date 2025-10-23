module instr_reg (
    input clk,
    input rst,
    input [1:0] fetch,
    input [7:0] data,
    output [2:0] ins,
    output [4:0] ad1,
    output [7:0] ad2
);

    // Internal registers implemented with continuous assignments
    reg [7:0] ins_p1, ins_p2;

    // Register updates using continuous assignments
    assign ins_p1 = (!rst) ? 8'b0 : 
                   (fetch[0]) ? data : ins_p1;
    
    assign ins_p2 = (!rst) ? 8'b0 : 
                   (fetch[1]) ? data : ins_p2;

    // Combinational output logic remains same
    assign ins = ins_p1[7:5];
    assign ad1 = ins_p1[4:0];
    assign ad2 = ins_p2;

endmodule