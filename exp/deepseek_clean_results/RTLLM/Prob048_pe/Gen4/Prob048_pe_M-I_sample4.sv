module pe (
    input wire clk,
    input wire rst,
    input wire en,        // Added enable signal
    input wire signed [31:0] a,
    input wire signed [31:0] b,
    output reg signed [31:0] c
);

    // Pipeline registers
    reg signed [31:0] a_reg, b_reg;
    reg signed [63:0] product_reg;
    reg signed [31:0] accum_reg;
    
    // Internal signals
    wire signed [63:0] product;
    wire signed [63:0] next_accum;
    wire overflow_pos, overflow_neg;
    
    // Calculate product
    assign product = a_reg * b_reg;
    
    // Overflow detection
    assign next_accum = { {32{accum_reg[31]}}, accum_reg } + product;
    assign overflow_pos = ~accum_reg[31] & ~product[63] & next_accum[63];
    assign overflow_neg = accum_reg[31] & product[63] & ~next_accum[63];
    
    always @(posedge clk) begin
        if (rst) begin
            // Reset all registers
            a_reg <= 32'd0;
            b_reg <= 32'd0;
            product_reg <= 64'd0;
            accum_reg <= 32'd0;
            c <= 32'd0;
        end else if (en) begin
            // Pipeline stage 1: register inputs and multiply
            a_reg <= a;
            b_reg <= b;
            
            // Pipeline stage 2: accumulate with saturation
            product_reg <= product;
            
            if (overflow_pos) begin
                accum_reg <= 32'h7FFFFFFF; // Saturate positive
            end else if (overflow_neg) begin
                accum_reg <= 32'h80000000;  // Saturate negative
            end else begin
                accum_reg <= accum_reg + product[31:0];
            end
            
            // Output registered version
            c <= accum_reg;
        end
    end

endmodule