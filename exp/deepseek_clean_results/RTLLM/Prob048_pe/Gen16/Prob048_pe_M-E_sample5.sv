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
    reg signed [63:0] accumulator;
    
    // Internal signals
    wire signed [63:0] product;
    wire signed [63:0] next_acc;
    wire overflow_detected;

    // Stage 1: Input registration and multiplication
    always @(posedge clk) begin
        if (rst) begin
            a_reg <= 32'd0;
            b_reg <= 32'd0;
            product_reg <= 64'd0;
        end else begin
            a_reg <= a;
            b_reg <= b;
            product_reg <= a_reg * b_reg;
        end
    end

    // Stage 2: Saturation accumulation
    assign product = product_reg;
    assign next_acc = accumulator + product;
    
    // Overflow detection (check if result exceeds 32-bit range)
    assign overflow_detected = (next_acc > 63'sd2147483647) || 
                              (next_acc < -63'sd2147483648);

    always @(posedge clk) begin
        if (rst) begin
            accumulator <= 64'd0;
            c <= 32'd0;
            overflow <= 1'b0;
        end else begin
            // Update accumulator (64-bit precision)
            accumulator <= next_acc;
            
            // Apply saturation
            if (overflow_detected) begin
                overflow <= 1'b1;
                c <= (next_acc > 0) ? 32'h7FFFFFFF : 32'h80000000;
            end else begin
                overflow <= 1'b0;
                c <= next_acc[31:0];
            end
        end
    end

endmodule