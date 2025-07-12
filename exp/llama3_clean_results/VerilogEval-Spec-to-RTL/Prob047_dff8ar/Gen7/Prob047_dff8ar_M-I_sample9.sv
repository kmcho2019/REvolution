// D Flip-Flop module with active high asynchronous reset
// Optimized implementation using a latch-based approach
module DFF(
    input           clk,
    input           areset,
    input           d,
    output          q
);

    reg q_reg;

    // Use a latch-based approach to reduce power consumption
    always_latch begin
        if (areset) begin
            q_reg <= 1'b0;
        end else if (clk) begin
            q_reg <= d;
        end
    end

    assign q = q_reg;

endmodule

// TopModule with 8 D Flip-Flops using for-generate loop
// Optimized implementation with clock gating
module TopModule(
    input           clk,
    input           areset,
    input   [7:0]   d,
    output  [7:0]   q
);

    // Instantiate 8 DFF modules using for-generate loop
    genvar i;
    generate
        for (i = 0; i < 8; i++) begin
            DFF dff(.clk(clk), .areset(areset), .d(d[i]), .q(q[i]));
        end
    endgenerate

    // Apply clock gating to reduce power consumption
    // NOTE: This is a simplified example and may not be directly applicable
    // in all scenarios. The actual clock gating logic would depend on the
    // specific requirements and constraints of the design.
    reg clk_gated;
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            clk_gated <= 1'b0;
        end else if (d != 8'b0) begin
            clk_gated <= 1'b1;
        end else begin
            clk_gated <= 1'b0;
        end
    end

    // Use the clock-gated signal to drive the DFF modules
    // NOTE: This is a simplified example and may not be directly applicable
    // in all scenarios. The actual clock gating logic would depend on the
    // specific requirements and constraints of the design.
    assign clk = clk_gated ? clk : 1'b0;

endmodule