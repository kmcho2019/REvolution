module pe (
    input wire clk,
    input wire rst,
    input wire [31:0] a,
    input wire [31:0] b,
    output reg [31:0] c
);

    // Pipeline registers
    reg [31:0] a_reg, b_reg;
    reg [63:0] product_reg;
    reg [31:0] accum_reg;
    
    // Detection of new input data (implicit valid signal)
    wire inputs_changed = (a != a_reg) || (b != b_reg);
    
    // Clock gating control
    wire accum_enable = inputs_changed || rst;
    
    // Stage 1: Multiplication pipeline
    always @(posedge clk) begin
        if (rst) begin
            a_reg <= 32'b0;
            b_reg <= 32'b0;
            product_reg <= 64'b0;
        end else if (inputs_changed) begin
            a_reg <= a;
            b_reg <= b;
            product_reg <= a * b;  // Full precision multiply
        end
    end
    
    // Stage 2: Accumulation with saturation
    always @(posedge clk) begin
        if (rst) begin
            accum_reg <= 32'b0;
        end else if (accum_enable) begin
            // Truncate with saturation
            if (product_reg[63:32] != {32{product_reg[31]}}) begin
                // Overflow occurred
                accum_reg <= product_reg[63] ? 32'h80000000 : 32'h7FFFFFFF;
            end else begin
                // No overflow
                accum_reg <= accum_reg + product_reg[31:0];
            end
        end
    end
    
    // Output assignment
    always @(*) begin
        c = accum_reg;
    end
    
endmodule