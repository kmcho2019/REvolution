module instr_reg (
    input clk,
    input rst,
    input [1:0] fetch,
    input [7:0] data,
    output reg [2:0] ins,
    output reg [4:0] ad1,
    output reg [7:0] ad2
);

    reg [7:0] ins_p1, ins_p2;
    wire p1_en = fetch[0] & rst;
    wire p2_en = fetch[1] & rst;

    // Register p1 with clock gating and output assignment
    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            ins_p1 <= 0;
            ins <= 0;
            ad1 <= 0;
        end
        else if (p1_en) begin
            ins_p1 <= data;
            ins <= data[7:5];
            ad1 <= data[4:0];
        end
    end

    // Register p2 with clock gating and output assignment
    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            ins_p2 <= 0;
            ad2 <= 0;
        end
        else if (p2_en) begin
            ins_p2 <= data;
            ad2 <= data;
        end
    end

endmodule