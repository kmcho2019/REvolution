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
    wire clk_gated = clk & (|fetch);  // Clock gating when fetch is active

    always @(posedge clk_gated or negedge rst) begin
        if (!rst) begin
            ins_p1 <= 0;
            ins_p2 <= 0;
        end else begin
            ins_p1 <= fetch[0] ? data : ins_p1;  // Power-optimized update
            ins_p2 <= fetch[1] ? data : ins_p2;
        end
    end

    // Direct output assignments from registers
    assign ins = ins_p1[7:5];
    assign ad1 = ins_p1[4:0];
    assign ad2 = ins_p2;

endmodule