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
    reg [7:0] ins_p1_reg, ins_p2_reg;

    // Dual-edge capture
    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            ins_p1 <= 0;
            ins_p1_reg <= 0;
        end else if (fetch[0]) begin
            ins_p1 <= data;
            ins_p1_reg <= data;  // Pipeline stage
        end
    end

    always @(negedge clk or negedge rst) begin
        if (!rst) begin
            ins_p2 <= 0;
            ins_p2_reg <= 0;
        end else if (fetch[1]) begin
            ins_p2 <= data;
            ins_p2_reg <= data;  // Pipeline stage
        end
    end

    // Output generation with pipeline
    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            ins <= 0;
            ad1 <= 0;
            ad2 <= 0;
        end else begin
            ins <= ins_p1_reg[7:5];
            ad1 <= ins_p1_reg[4:0];
            ad2 <= ins_p2_reg;
        end
    end

endmodule