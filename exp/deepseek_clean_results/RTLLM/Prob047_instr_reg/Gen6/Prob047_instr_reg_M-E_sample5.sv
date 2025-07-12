module instr_reg (
    input clk,
    input rst,
    input [1:0] fetch,
    input [7:0] data,
    output reg [2:0] ins,
    output reg [4:0] ad1,
    output reg [7:0] ad2
);

    // Pipeline stage 1 registers
    reg [7:0] stage1_p1;
    reg [7:0] stage1_p2;
    reg stage1_valid;

    // Clock gating signals
    wire stage2_clk_en;
    wire stage2_clk;

    // Stage 1: Instruction capture and field separation
    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            stage1_p1 <= 8'b0;
            stage1_p2 <= 8'b0;
            stage1_valid <= 1'b0;
        end else begin
            case (fetch)
                2'b01: begin
                    stage1_p1 <= data;
                    stage1_valid <= 1'b1;
                end
                2'b10: begin
                    stage1_p2 <= data;
                    stage1_valid <= 1'b1;
                end
                default: stage1_valid <= 1'b0;
            endcase
        end
    end

    // Clock gating for stage 2 (power optimization)
    assign stage2_clk_en = stage1_valid;
    assign stage2_clk = clk & stage2_clk_en;

    // Stage 2: Output registration
    always @(posedge stage2_clk or negedge rst) begin
        if (!rst) begin
            ins <= 3'b0;
            ad1 <= 5'b0;
            ad2 <= 8'b0;
        end else begin
            ins <= stage1_p1[7:5];
            ad1 <= stage1_p1[4:0];
            ad2 <= stage1_p2;
        end
    end

endmodule