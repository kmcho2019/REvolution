module pe (
    input wire clk,
    input wire rst,
    input wire en,        // Enable signal for power savings
    input wire signed [31:0] a,
    input wire signed [31:0] b,
    output reg signed [31:0] c
);

    // Pipeline registers
    reg signed [31:0] a_reg, b_reg;
    reg signed [31:0] a_low, a_high, b_low, b_high;
    reg signed [31:0] pp0, pp1, pp2, pp3;
    reg signed [31:0] sum_stage1;
    
    // Clock gating control
    wire clk_en = en | rst;
    wire gated_clk;
    
    // Generate gated clock
    CLK_GATE clk_gate (
        .CLK(clk),
        .EN(clk_en),
        .GCLK(gated_clk)
    );

    // Stage 1: Operand decomposition and partial products
    always @(posedge gated_clk) begin
        if (rst) begin
            a_reg <= 32'sd0;
            b_reg <= 32'sd0;
            {a_low, a_high} <= {16'sd0, 16'sd0};
            {b_low, b_high} <= {16'sd0, 16'sd0};
        end else if (en) begin
            a_reg <= a;
            b_reg <= b;
            a_low <= a[15:0];
            a_high <= a[31:16];
            b_low <= b[15:0];
            b_high <= b[31:16];
        end
    end

    // Stage 2: Partial product generation (combinational)
    always @(*) begin
        if (en) begin
            pp0 = a_low * b_low;
            pp1 = a_low * b_high;
            pp2 = a_high * b_low;
            pp3 = a_high * b_high;
        end else begin
            pp0 = 32'sd0;
            pp1 = 32'sd0;
            pp2 = 32'sd0;
            pp3 = 32'sd0;
        end
    end

    // Stage 3: Partial sum (registered)
    always @(posedge gated_clk) begin
        if (rst) begin
            sum_stage1 <= 32'sd0;
        end else if (en) begin
            sum_stage1 <= pp0 + (pp1 << 16) + (pp2 << 16);
        end
    end

    // Stage 4: Final accumulation with overflow protection
    always @(posedge gated_clk) begin
        if (rst) begin
            c <= 32'sd0;
        end else if (en) begin
            // Saturating addition for overflow protection
            if ((sum_stage1 > 0) && (c > (32'sh7FFFFFFF - sum_stage1))) begin
                c <= 32'sh7FFFFFFF; // Positive saturation
            end else if ((sum_stage1 < 0) && (c < (32'sh80000000 - sum_stage1))) begin
                c <= 32'sh80000000; // Negative saturation
            end else begin
                c <= c + sum_stage1;
            end
        end
    end

endmodule

module CLK_GATE (
    input CLK,
    input EN,
    output GCLK
);
    // Clock gating cell implementation
    reg en_latch;
    always @(*) begin
        if (!CLK) en_latch = EN;
    end
    
    assign GCLK = CLK & en_latch;
endmodule