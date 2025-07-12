module pe (
    input wire clk,
    input wire rst,
    input wire [31:0] a,
    input wire [31:0] b,
    output reg [31:0] c
);

    // Pipeline registers
    reg [31:0] a_reg, b_reg;
    reg [31:0] c_acc;
    
    // Partial products
    wire [31:0] pp0, pp1;
    wire [63:0] full_product;
    
    // Carry-save signals
    reg [63:0] sum, carry;
    
    // Bypass control
    wire bypass = (a_reg == a) && (b_reg == b);
    
    // Stage 1: Partial product generation
    always @(posedge clk) begin
        if (rst) begin
            a_reg <= 32'b0;
            b_reg <= 32'b0;
        end else begin
            a_reg <= a;
            b_reg <= b;
        end
    end
    
    // Generate partial products (16x16 each)
    assign pp0 = a[15:0] * b[15:0];
    assign pp1 = a[31:16] * b[31:16];
    
    // Full product for bypass mode
    assign full_product = a * b;
    
    // Stage 2: Partial product reduction (carry-save)
    always @(posedge clk) begin
        if (rst) begin
            sum <= 64'b0;
            carry <= 64'b0;
        end else begin
            sum <= {32'b0, pp0} + ({pp1, 16'b0} << 16);
            carry <= (sum & carry) << 1;
            sum <= sum ^ carry;
        end
    end
    
    // Stage 3: Final accumulation
    always @(posedge clk) begin
        if (rst) begin
            c <= 32'b0;
            c_acc <= 32'b0;
        end else begin
            if (bypass) begin
                c <= c + full_product[31:0];
            end else begin
                // Final carry resolution
                c_acc <= sum[31:0] + carry[31:0];
                c <= c + c_acc;
            end
        end
    end

endmodule