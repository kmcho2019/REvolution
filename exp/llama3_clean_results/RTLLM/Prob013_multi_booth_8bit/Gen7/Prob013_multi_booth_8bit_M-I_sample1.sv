module multi_booth_8bit(
    input clk,
    input reset,
    input [7:0] a,
    input [7:0] b,
    output reg [15:0] p,
    output reg rdy
);

reg [15:0] multiplicand_reg;
reg [15:0] multiplier_reg;
reg [4:0] ctr;
reg [15:0] product_accumulator;
reg multiplicand_sign;

always @(posedge clk) begin
    if(reset) begin
        multiplicand_reg <= { {8{b[7]}}, b };
        multiplier_reg <= { {8{a[7]}}, a };
        product_accumulator <= 0;
        ctr <= 0;
        rdy <= 0;
    end else if(ctr < 16) begin
        // Booth encoding
        case({ multiplier_reg[ctr+1], multiplier_reg[ctr] })
            2'b00: product_accumulator <= product_accumulator;
            2'b01: product_accumulator <= product_accumulator + multiplicand_reg;
            2'b10: product_accumulator <= product_accumulator - multiplicand_reg;
            2'b11: product_accumulator <= product_accumulator + multiplicand_reg;
        endcase
        
        // Shift multiplicand
        multiplicand_reg <= multiplicand_reg << 2;
        
        // Increment counter
        ctr <= ctr + 2;
    end else begin
        p <= product_accumulator;
        rdy <= 1;
    end
end

endmodule