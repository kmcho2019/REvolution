module pe (
    input wire clk,
    input wire rst,
    input wire signed [31:0] a,
    input wire signed [31:0] b,
    output wire signed [31:0] c
);

    // Pipeline registers
    reg signed [31:0] a_reg, b_reg;
    wire signed [63:0] product;
    reg signed [63:0] product_reg;
    
    // Zero detection logic
    wire a_zero = (a == 32'sb0);
    wire b_zero = (b == 32'sb0);
    reg zero_detect;
    
    // Carry-save accumulator
    reg signed [31:0] sum;
    reg signed [31:0] carry;
    wire signed [31:0] final_sum;
    
    // Output with saturation logic
    reg signed [31:0] c_reg;
    
    // Multiplier pipeline stage 1
    always @(posedge clk) begin
        if (rst) begin
            a_reg <= 32'sb0;
            b_reg <= 32'sb0;
            zero_detect <= 1'b0;
        end else begin
            a_reg <= a;
            b_reg <= b;
            zero_detect <= a_zero | b_zero;
        end
    end
    
    // Multiplier implementation (partial products)
    assign product = a_reg * b_reg;
    
    // Multiplier pipeline stage 2
    always @(posedge clk) begin
        if (rst) begin
            product_reg <= 64'sb0;
        end else begin
            product_reg <= zero_detect ? 64'sb0 : product;
        end
    end
    
    // Carry-save accumulation
    always @(posedge clk) begin
        if (rst) begin
            sum <= 32'sb0;
            carry <= 32'sb0;
        end else begin
            {carry, sum} <= sum + carry + product_reg[31:0];
        end
    end
    
    // Final addition (only when needed)
    assign final_sum = sum + carry;
    
    // Output register with saturation
    always @(posedge clk) begin
        if (rst) begin
            c_reg <= 32'sb0;
        end else begin
            // Check for overflow/underflow
            if (~(sum[31] ^ carry[31]) & (sum[31] ^ final_sum[31])) begin
                c_reg <= sum[31] ? 32'h80000000 : 32'h7FFFFFFF;
            end else begin
                c_reg <= final_sum;
            end
        end
    end
    
    assign c = c_reg;

endmodule