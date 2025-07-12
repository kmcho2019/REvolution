module pe (
    input wire clk,
    input wire rst,
    input wire signed [31:0] a,
    input wire signed [31:0] b,
    output reg signed [31:0] c,
    output reg overflow
);

    // Pipeline registers
    reg signed [31:0] a_reg, b_reg;
    reg signed [63:0] product_reg;
    reg signed [31:0] accum_reg;
    
    // Overflow detection signals
    wire add_overflow;
    wire signed [31:0] next_accum;
    
    // Constants for saturation
    localparam MAX_VAL = 32'h7FFFFFFF;
    localparam MIN_VAL = 32'h80000000;
    
    // Calculate next accumulation value
    assign next_accum = accum_reg + product_reg[31:0];
    
    // Overflow occurs if:
    // 1. Both operands positive and result negative
    // 2. Both operands negative and result positive
    assign add_overflow = (~accum_reg[31] & ~product_reg[31] & next_accum[31]) |
                         (accum_reg[31] & product_reg[31] & ~next_accum[31]);
    
    always @(posedge clk) begin
        if (rst) begin
            // Reset all registers
            a_reg <= 32'd0;
            b_reg <= 32'd0;
            product_reg <= 64'd0;
            accum_reg <= 32'd0;
            c <= 32'd0;
            overflow <= 1'b0;
        end else begin
            // Pipeline stage 1: Register inputs and multiply
            a_reg <= a;
            b_reg <= b;
            product_reg <= a_reg * b_reg;
            
            // Pipeline stage 2: Accumulate with saturation
            if (add_overflow) begin
                accum_reg <= (product_reg[31] ? MIN_VAL : MAX_VAL);
                overflow <= 1'b1;
            end else begin
                accum_reg <= next_accum;
                overflow <= 1'b0;
            end
            
            // Output the accumulated value
            c <= accum_reg;
        end
    end
    
    // Only update when inputs change (power optimization)
    // Note: This is commented out as it may not be desired in all applications
    /*
    always @(a or b) begin
        a_changed = (a != a_reg);
        b_changed = (b != b_reg);
        enable_mult = a_changed | b_changed;
    end
    */
    
endmodule