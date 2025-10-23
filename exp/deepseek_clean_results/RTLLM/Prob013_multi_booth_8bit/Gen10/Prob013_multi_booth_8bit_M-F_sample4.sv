module multi_booth_8bit (
    input clk,
    input reset,
    input [7:0] a,
    input [7:0] b,
    output reg [15:0] p,
    output reg rdy
);

    reg [2:0] ctr;          // 3-bit counter (0-4)
    reg [15:0] multiplicand;
    reg [9:0] multiplier;   // 8-bit + 2-bit lookahead
    reg [16:0] product;     // 17-bit for overflow

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            multiplicand <= {{8{a[7]}}, a};
            multiplier <= {b, 2'b0};
            product <= 17'b0;
            ctr <= 3'b0;
            rdy <= 1'b0;
        end else if (!rdy) begin
            // Radix-4 Booth encoding
            case (multiplier[2:0])
                3'b001, 3'b010: product <= product + multiplicand;
                3'b011:         product <= product + (multiplicand << 1);
                3'b100:         product <= product - (multiplicand << 1);
                3'b101, 3'b110: product <= product - multiplicand;
                default:        product <= product;  // 000,111 cases
            endcase

            // Arithmetic right shift by 2 bits
            multiplier <= {{2{multiplier[9]}}, multiplier[9:2]};
            multiplicand <= multiplicand << 2;
            
            // Update counter and ready signal
            ctr <= ctr + 1;
            if (ctr == 3'b11) begin
                p <= product[15:0];
                rdy <= 1'b1;
            end
        end
    end

endmodule