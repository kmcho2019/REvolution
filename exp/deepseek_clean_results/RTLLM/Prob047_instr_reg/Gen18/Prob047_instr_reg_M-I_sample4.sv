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
    wire p1_en = fetch[0] & rst;  // Clock gating condition for ins_p1
    wire p2_en = fetch[1] & rst;  // Clock gating condition for ins_p2

    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            ins_p1 <= 8'b0;
            ins_p2 <= 8'b0;
        end
        else begin
            if (p1_en) ins_p1 <= data;
            if (p2_en) ins_p2 <= data;
        end
    end

    // Combinational output assignments
    assign ins = ins_p1[7:5];
    assign ad1 = ins_p1[4:0];
    assign ad2 = ins_p2;

endmodule