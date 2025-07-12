module multi_booth_8bit (
    input clk,
    input reset,
    input [7:0] a,
    input [7:0] b,
    output reg [15:0] p,
    output rdy
);

    reg [4:0] ctr;
    reg [15:0] multiplicand;
    reg [15:0] multiplier;
    reg [15:0] product;

    // Ready signal is combinational
    assign rdy = (ctr == 5'd4);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            ctr <= 5'b0;
            multiplicand <= {{8{a[7]}}, a};
            multiplier <= {{8{b[7]}}, b} << 1; // Pre-shift for Radix-4
            product <= 16'b0;
            p <= 16'b0;
        end else begin
            if (ctr < 4) begin
                // Radix-4 Booth encoding
                case (multiplier[2:0])
                    3'b000, 3'b111: product <= product;
                    3'b001, 3'b010: product <= product + multiplicand;
                    3'b011: product <= product + (multiplicand << 1);
                    3'b100: product <= product - (multiplicand << 1);
                    default: product <= product - multiplicand;
                endcase

                // Shift multiplicand and multiplier
                multiplicand <= multiplicand << 2;
                multiplier <= multiplier >> 2;
                ctr <= ctr + 1;
            end else begin
                p <= product; // Final result
            end
        end
    end

endmodule