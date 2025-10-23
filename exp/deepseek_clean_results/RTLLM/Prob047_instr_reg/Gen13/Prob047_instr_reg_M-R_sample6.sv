module instr_reg (
    input clk,
    input rst,
    input [1:0] fetch,
    input [7:0] data,
    output [2:0] ins,
    output [4:0] ad1,
    output [7:0] ad2
);

    // Register declarations
    reg [7:0] ins_p1, ins_p2;

    // Clocked register updates using continuous assignments
    wire [7:0] next_ins_p1 = !rst ? 8'b0 : (fetch[0] ? data : ins_p1);
    wire [7:0] next_ins_p2 = !rst ? 8'b0 : (fetch[1] ? data : ins_p2);

    // Register updates on clock edge
    always @(posedge clk) begin
        ins_p1 <= next_ins_p1;
        ins_p2 <= next_ins_p2;
    end

    // Output assignments
    assign ins = ins_p1[7:5];    // Upper 3 bits
    assign ad1 = ins_p1[4:0];    // Lower 5 bits
    assign ad2 = ins_p2;         // Full 8 bits

endmodule