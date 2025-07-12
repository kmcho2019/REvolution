module pe (
    input wire clk,
    input wire rst_n,          // Active-low reset
    input wire en,             // Enable signal
    input wire signed [31:0] a,
    input wire signed [31:0] b,
    output reg signed [31:0] c
);

    // Pipeline registers
    reg signed [31:0] a_reg, b_reg;
    reg signed [63:0] product_reg;
    
    // Internal signals
    wire signed [63:0] product;
    wire signed [63:0] sum;
    wire overflow_pos, overflow_neg;
    
    // Synchronous reset logic
    reg rst_sync;
    always @(posedge clk) begin
        rst_sync <= ~rst_n;
    end
    
    // Stage 1: Input registration and multiplication
    always @(posedge clk) begin
        if (rst_sync) begin
            a_reg <= 32'd0;
            b_reg <= 32'd0;
        end else if (en) begin
            a_reg <= a;
            b_reg <= b;
        end
    end
    
    assign product = a_reg * b_reg;
    
    // Stage 2: Product registration and accumulation
    always @(posedge clk) begin
        if (rst_sync) begin
            product_reg <= 64'd0;
        end else if (en) begin
            product_reg <= product;
        end
    end
    
    // Overflow detection
    assign sum = { {32{c[31]}}, c } + product_reg;
    assign overflow_pos = (~c[31] & ~product_reg[31] & sum[31]);
    assign overflow_neg = (c[31] & product_reg[31] & ~sum[31]);
    
    // Accumulation with saturation
    always @(posedge clk) begin
        if (rst_sync) begin
            c <= 32'd0;
        end else if (en) begin
            case ({overflow_pos, overflow_neg})
                2'b10: c <= 32'h7FFFFFFF; // Positive saturation
                2'b01: c <= 32'h80000000; // Negative saturation
                default: c <= sum[31:0];   // Normal case
            endcase
        end
    end

endmodule