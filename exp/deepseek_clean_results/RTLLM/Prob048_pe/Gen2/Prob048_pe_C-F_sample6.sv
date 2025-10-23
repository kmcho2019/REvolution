module pe (
    input wire clk,
    input wire rst,
    input wire signed [31:0] a,
    input wire signed [31:0] b,
    output reg signed [31:0] c
);

    // Pipeline registers
    reg signed [31:0] a_reg, b_reg;
    reg signed [31:0] c_next;
    reg signed [31:0] product_reg;
    reg compute_en;

    // Input change detection
    wire inputs_changed = (a != a_reg) || (b != b_reg);

    // Clock gating condition
    always @(*) begin
        compute_en = rst || inputs_changed || (a != 0) || (b != 0);
    end

    // Stage 1: Input registration and multiplication
    always @(posedge clk) begin
        if (compute_en) begin
            a_reg <= a;
            b_reg <= b;
            // Only compute lower 32 bits of product
            product_reg <= a * b;
        end
    end

    // Stage 2: Accumulation
    always @(posedge clk) begin
        if (rst) begin
            c <= 32'd0;
            c_next <= 32'd0;
        end else if (compute_en) begin
            c_next <= c + product_reg;
            c <= c_next;  // Pipelined output
        end
    end

endmodule