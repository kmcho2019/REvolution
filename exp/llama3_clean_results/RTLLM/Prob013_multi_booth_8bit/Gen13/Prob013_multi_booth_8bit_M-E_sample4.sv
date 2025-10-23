module multi_booth_8bit(
    input clk,
    input reset,
    input [7:0] a,
    input [7:0] b,
    output reg [15:0] p,
    output reg rdy
);

reg [7:0] multiplier_reg;
reg [7:0] multiplicand_reg;
reg [15:0] partial_product;
reg [15:0] product;
reg [4:0] ctr;
reg rdy_reg;

assign p = product;
assign rdy = rdy_reg;

always @(posedge clk) begin
    if (reset) begin
        multiplier_reg <= a;
        multiplicand_reg <= b;
        partial_product <= 0;
        product <= 0;
        ctr <= 0;
        rdy_reg <= 0;
    end else begin
        if (ctr < 8) begin
            // Booth encoding and sign-bit detection
            reg [1:0] booth_code;
            booth_code = {multiplier_reg[7], multiplier_reg[6]};
            case (booth_code)
                2'b00: partial_product <= partial_product;
                2'b01: partial_product <= partial_product + multiplicand_reg;
                2'b10: partial_product <= partial_product - multiplicand_reg;
                2'b11: partial_product <= partial_product + (multiplicand_reg << 1);
            endcase
            // Shift multiplier
            multiplier_reg <= multiplier_reg << 1;
            // Increment counter
            ctr <= ctr + 1;
        end else begin
            // Final accumulation and result formation
            product <= partial_product;
            rdy_reg <= 1;
        end
    end
end

endmodule