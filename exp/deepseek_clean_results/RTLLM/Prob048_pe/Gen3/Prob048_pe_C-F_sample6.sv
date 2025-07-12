module pe (
    input wire clk,
    input wire rst,
    input wire signed [31:0] a,
    input wire signed [31:0] b,
    output reg signed [31:0] c
);

    // Internal signals
    wire signed [63:0] full_product;
    wire signed [31:0] truncated_product;
    reg signed [31:0] next_c;

    // Calculate full 64-bit product
    assign full_product = a * b;
    
    // Truncate to 32 bits with overflow detection
    assign truncated_product = (full_product > 32'sh7FFFFFFF) ? 32'sh7FFFFFFF :
                             (full_product < -32'sh80000000) ? -32'sh80000000 :
                             full_product[31:0];

    // Next state logic with saturation
    always @(*) begin
        if (rst) begin
            next_c = 32'd0;
        end else begin
            // Check for overflow in accumulation
            if ((c > 0) && (truncated_product > 0) && (c + truncated_product < c)) begin
                next_c = 32'sh7FFFFFFF; // Positive overflow
            end else if ((c < 0) && (truncated_product < 0) && (c + truncated_product > c)) begin
                next_c = -32'sh80000000; // Negative overflow
            end else begin
                next_c = c + truncated_product;
            end
        end
    end

    // Register update
    always @(posedge clk) begin
        c <= next_c;
    end

endmodule