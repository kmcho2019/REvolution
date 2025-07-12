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
    wire clk_enable = |fetch;

    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            ins_p1 <= 0;
            ins_p2 <= 0;
        end else if (clk_enable) begin
            ins_p1 <= fetch[0] ? data : ins_p1;
            ins_p2 <= fetch[1] ? data : ins_p2;
        end
    end

    assign {ins, ad1} = ins_p1;
    assign ad2 = ins_p2;

endmodule