module multi_8bit_pipelined(
    input   clk,  // Clock signal
    input   rst_n,  // Active low reset
    input   [7:0] A,  // First 8-bit input operand (multiplicand)
    input   [7:0] B,  // Second 8-bit input operand (multiplier)
    output  [15:0] product  // 16-bit output representing the product of A and B
);

    reg [7:0] shift_reg;  // Register to hold the current bit of the multiplier
    reg [15:0] product_reg;  // Register to accumulate the product
    reg [15:0] multiplicand_shifted;  // Register to hold the shifted multiplicand
    
    integer i;  // Loop counter
    
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            // Reset the registers
            shift_reg <= 8'd0;
            product_reg <= 16'd0;
            multiplicand_shifted <= 16'd0;
        end else begin
            // Initialize the registers for the first clock cycle
            if (shift_reg == 8'd0) begin
                shift_reg <= B;
                product_reg <= 16'd0;
            end else begin
                // Shift the multiplicand based on the current bit of the multiplier
                if (shift_reg[0] == 1'b1) begin
                    multiplicand_shifted <= {8'd0, A} << (shift_reg[7:1]);
                    product_reg <= product_reg + multiplicand_shifted;
                end
                
                // Right shift the multiplier to move to the next bit
                shift_reg <= shift_reg >> 1;
            end
        end
    end
    
    // Output the final product
    assign product = (shift_reg == 8'd0)? product_reg : 16'd0;

endmodule