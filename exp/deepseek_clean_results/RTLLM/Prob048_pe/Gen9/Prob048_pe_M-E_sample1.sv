module pe (
    input wire clk,
    input wire rst,
    input wire en,         // Enable signal for power gating
    input wire precision,  // 0=16-bit, 1=32-bit mode
    input wire [31:0] a,
    input wire [31:0] b,
    output reg [31:0] c
);

    // Pipeline registers
    reg [31:0] a_reg, b_reg;
    reg [63:0] product_reg;
    reg precision_reg;
    
    // Zero detection signals
    wire a_zero = (a == 32'b0);
    wire b_zero = (b == 32'b0);
    wire skip_op = a_zero | b_zero;
    
    // Operand isolation
    wire [31:0] a_iso = en ? a : 32'b0;
    wire [31:0] b_iso = en ? b : 32'b0;
    
    // Dynamic precision multiplexing
    wire [31:0] a_prec = precision ? a_iso : {16'b0, a_iso[15:0]};
    wire [31:0] b_prec = precision ? b_iso : {16'b0, b_iso[15:0]};
    
    // Multiplier stage (combinational)
    wire [63:0] product = skip_op ? 64'b0 : a_prec * b_prec;
    
    // Clock gating for accumulator
    wire accum_clk = clk & en;
    
    // Pipeline stage 1: Register inputs and product
    always @(posedge clk) begin
        if (rst) begin
            a_reg <= 32'b0;
            b_reg <= 32'b0;
            product_reg <= 64'b0;
            precision_reg <= 1'b0;
        end else if (en) begin
            a_reg <= a_iso;
            b_reg <= b_iso;
            product_reg <= product;
            precision_reg <= precision;
        end
    end
    
    // Saturation detection
    wire [32:0] accum_ext = {1'b0, c} + {1'b0, product_reg[31:0]};
    wire overflow = accum_ext[32];
    
    // Pipeline stage 2: Accumulate with saturation
    always @(posedge accum_clk or posedge rst) begin
        if (rst) begin
            c <= 32'b0;
        end else begin
            if (overflow) begin
                c <= 32'h7FFFFFFF;  // Saturate to max positive
            end else begin
                c <= accum_ext[31:0];
            end
        end
    end

endmodule