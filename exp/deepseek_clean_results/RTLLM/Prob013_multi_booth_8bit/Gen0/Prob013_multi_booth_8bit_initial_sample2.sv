module multi_booth_8bit (
    input clk,
    input reset,
    input [7:0] a,
    input [7:0] b,
    output reg [15:0] p,
    output reg rdy
);

reg [15:0] multiplicand;  // Sign-extended multiplicand
reg [15:0] multiplier;    // Sign-extended multiplier with extra bit
reg [4:0] ctr;            // 5-bit counter (0-16)
reg [15:0] product;       // Accumulated product
reg prev_lsb;             // Previous LSB for Booth encoding

always @(posedge clk or posedge reset) begin
    if (reset) begin
        // Initialize on reset
        multiplicand <= {{8{a[7]}}, a};
        multiplier <= {{8{b[7]}}, b};
        product <= 16'b0;
        ctr <= 5'b0;
        prev_lsb <= 1'b0;
        rdy <= 1'b0;
    end else begin
        if (ctr < 8) begin
            case ({multiplier[1:0], prev_lsb})
                3'b000, 3'b111: begin
                    // Do nothing
                    product <= product;
                end
                3'b001, 3'b010: begin
                    // Add multiplicand
                    product <= product + multiplicand;
                end
                3'b011: begin
                    // Add 2*multiplicand
                    product <= product + (multiplicand << 1);
                end
                3'b100: begin
                    // Subtract 2*multiplicand
                    product <= product - (multiplicand << 1);
                end
                3'b101, 3'b110: begin
                    // Subtract multiplicand
                    product <= product - multiplicand;
                end
            endcase
            
            // Arithmetic right shift of product and multiplier
            {product, multiplier} <= {product[15], product[15:1], multiplier[15:1]};
            prev_lsb <= multiplier[0];
            
            ctr <= ctr + 1;
            rdy <= 1'b0;
        end else begin
            // Multiplication complete
            p <= product;
            rdy <= 1'b1;
        end
    end
end

endmodule