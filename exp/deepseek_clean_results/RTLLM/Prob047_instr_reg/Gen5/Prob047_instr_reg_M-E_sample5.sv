module instr_reg (
    input clk,
    input rst,
    input [1:0] fetch,
    input [7:0] data,
    output reg [2:0] ins,
    output reg [4:0] ad1,
    output reg [7:0] ad2
);

    // Pipeline stage 1 registers (dual-edge triggered)
    reg [7:0] stage1_p1;
    reg [7:0] stage1_p2;
    reg stage1_valid;

    // Pipeline stage 2 registers
    reg [7:0] stage2_p1;
    reg [7:0] stage2_p2;
    reg stage2_valid;

    // Clock gating signals
    wire clk_gated = clk & (|fetch);

    // Dual-edge pipeline stage 1
    always @(posedge clk_gated or negedge rst) begin
        if (!rst) begin
            stage1_p1 <= 0;
            stage1_p2 <= 0;
            stage1_valid <= 0;
        end else begin
            if (fetch == 2'b01) begin
                stage1_p1 <= data;
                stage1_valid <= 1;
            end
            if (fetch == 2'b10) begin
                stage1_p2 <= data;
                stage1_valid <= 1;
            end
        end
    end

    // Falling edge pipeline stage 2
    always @(negedge clk_gated or negedge rst) begin
        if (!rst) begin
            stage2_p1 <= 0;
            stage2_p2 <= 0;
            stage2_valid <= 0;
        end else if (stage1_valid) begin
            stage2_p1 <= stage1_p1;
            stage2_p2 <= stage1_p2;
            stage2_valid <= 1;
        end
    end

    // Output registers updated on rising edge
    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            ins <= 0;
            ad1 <= 0;
            ad2 <= 0;
        end else if (stage2_valid) begin
            ins <= stage2_p1[7:5];
            ad1 <= stage2_p1[4:0];
            ad2 <= stage2_p2;
        end
    end

endmodule