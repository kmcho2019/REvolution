module pe #(
    parameter WIDTH = 32,
    parameter SATURATE = 1  // 0: wrap-around, 1: saturate
) (
    input wire clk,
    input wire rst_n,  // Active-low asynchronous reset
    input wire signed [WIDTH-1:0] a,
    input wire signed [WIDTH-1:0] b,
    output reg signed [WIDTH-1:0] c,
    output reg overflow
);

    // Pipeline registers
    reg signed [WIDTH-1:0] a_reg, b_reg;
    reg signed [2*WIDTH-1:0] product_reg;
    reg signed [2*WIDTH-1:0] accumulator;
    
    // Internal signals
    wire signed [2*WIDTH-1:0] product;
    wire signed [2*WIDTH-1:0] next_accum;
    wire mult_enable = |a || |b;  // Operand isolation
    
    // Stage 1: Input registration
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            a_reg <= '0;
            b_reg <= '0;
        end else begin
            a_reg <= a;
            b_reg <= b;
        end
    end
    
    // Stage 2: Multiplication (with operand isolation)
    assign product = mult_enable ? a_reg * b_reg : '0;
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            product_reg <= '0;
        end else begin
            product_reg <= product;
        end
    end
    
    // Stage 3: Accumulation with overflow detection
    assign next_accum = accumulator + product_reg;
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            accumulator <= '0;
            c <= '0;
            overflow <= 1'b0;
        end else begin
            // Update accumulator (full precision)
            accumulator <= next_accum;
            
            // Detect overflow
            if (next_accum > (2**(WIDTH-1)-1) || 
               (next_accum < -(2**(WIDTH-1)))) begin
                overflow <= 1'b1;
                
                // Handle saturation if enabled
                if (SATURATE) begin
                    c <= next_accum[2*WIDTH-1] ? 
                         -(2**(WIDTH-1)) : 
                         (2**(WIDTH-1)-1);
                end else begin
                    c <= next_accum[WIDTH-1:0];  // Wrap-around
                end
            end else begin
                overflow <= 1'b0;
                c <= next_accum[WIDTH-1:0];  // Normal case
            end
        end
    end

endmodule