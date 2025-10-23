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
    wire p1_enable = fetch[0] & rst;
    wire p2_enable = fetch[1] & rst;

    // Clock-gated register updates
    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            ins_p1 <= 8'b0;
            ins_p2 <= 8'b0;
        end
        else begin
            if (p1_enable) ins_p1 <= data;
            if (p2_enable) ins_p2 <= data;
        end
    end

    // Registered outputs for better timing
    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            ins <= 3'b0;
            ad1 <= 5'b0;
            ad2 <= 8'b0;
        end
        else begin
            ins <= ins_p1[7:5];
            ad1 <= ins_p1[4:0];
            ad2 <= ins_p2;
        end
    end

endmodule