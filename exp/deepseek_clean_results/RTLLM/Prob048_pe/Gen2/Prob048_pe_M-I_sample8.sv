module pe (
    input wire clk,
    input wire rst,
    input wire signed [31:0] a,
    input wire signed [31:0] b,
    output reg signed [31:0] c
);

    // Pipeline registers
    reg signed [31:0] a_reg, b_reg;
    reg signed [31:0] product_reg;
    reg signed [31:0] c_next;
    
    // Clock gating signals
    wire inputs_zero = (a == 32'd0) && (b == 32'd0);
    wire clk_enable = ~inputs_zero || rst;
    
    // Overflow detection
    wire signed [31:0] product;
    wire overflow;
    assign product = a_reg * b_reg;
    assign overflow = (product[31] != a_reg[31]^b_reg[31]) && (a_reg != 32'd0) && (b_reg != 32'd0);
    
    always @(posedge clk) begin
        if (rst) begin
            // Synchronous reset with operand isolation
            a_reg <= 32'd0;
            b_reg <= 32'd0;
            product_reg <= 32'd0;
            c <= 32'd0;
        end else if (clk_enable) begin
            // Pipeline stage 1: Register inputs and multiply
            a_reg <= a;
            b_reg <= b;
            product_reg <= overflow ? {31'd0, product[31]} : product; // Saturate on overflow
            
            // Pipeline stage 2: Accumulate
            c <= c_next;
        end
    end
    
    // Combinational accumulation
    always @(*) begin
        if (rst)
            c_next = 32'd0;
        else
            c_next = c + product_reg;
    end

endmodule