module instr_reg (
    input clk,
    input rst,
    input [1:0] fetch,
    input [7:0] data,
    output [2:0] ins,
    output [4:0] ad1,
    output [7:0] ad2
);

    wire [7:0] next_ins_p1, next_ins_p2;
    reg [7:0] ins_p1, ins_p2;

    // Clock-gated next state logic
    assign next_ins_p1 = fetch[0] ? data : ins_p1;
    assign next_ins_p2 = fetch[1] ? data : ins_p2;

    // Register updates with reset
    always @(posedge clk) begin
        ins_p1 <= !rst ? 8'b0 : next_ins_p1;
        ins_p2 <= !rst ? 8'b0 : next_ins_p2;
    end

    // Output assignments remain the same
    assign ins = ins_p1[7:5];
    assign ad1 = ins_p1[4:0];
    assign ad2 = ins_p2;

endmodule