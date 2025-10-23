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
    wire p1_enable = fetch[0] & rst;
    wire p2_enable = fetch[1] & rst;

    // Separate always blocks for better timing
    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            ins_p1 <= 0;
        end else if (p1_enable) begin
            ins_p1 <= data;
        end
    end

    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            ins_p2 <= 0;
        end else if (p2_enable) begin
            ins_p2 <= data;
        end
    end

    // Operand isolation during reset
    assign ins = rst ? ins_p1[7:5] : 3'b0;
    assign ad1 = rst ? ins_p1[4:0] : 5'b0;
    assign ad2 = rst ? ins_p2 : 8'b0;

endmodule