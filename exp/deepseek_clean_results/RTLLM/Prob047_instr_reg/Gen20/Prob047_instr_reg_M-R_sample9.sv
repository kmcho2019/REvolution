module instr_reg (
    input clk,
    input rst,
    input [1:0] fetch,
    input [7:0] data,
    output [2:0] ins,
    output [4:0] ad1,
    output [7:0] ad2
);

    reg [7:0] ins_p1, ins_p2;
    wire [7:0] next_p1, next_p2;

    // Next state logic for registers
    assign next_p1 = (!rst) ? 8'b0 : 
                    (fetch == 2'b01) ? data : ins_p1;

    assign next_p2 = (!rst) ? 8'b0 : 
                    (fetch == 2'b10) ? data : ins_p2;

    // Register updates
    always @(posedge clk) begin
        ins_p1 <= next_p1;
        ins_p2 <= next_p2;
    end

    // Output assignments remain the same
    assign ins = ins_p1[7:5];
    assign ad1 = ins_p1[4:0];
    assign ad2 = ins_p2;

endmodule