module multi_booth_8bit(
    input clk,
    input reset,
    input [7:0] a,
    input [7:0] b,
    output reg [15:0] p,
    output reg rdy
);

// State definitions
localparam IDLE = 1'b0;
localparam CALC = 1'b1;

reg state;
reg [2:0] ctr;          // 3-bit counter (0-3)
reg [16:0] multiplicand; // 17-bit (for proper sign extension during shifts)
reg [16:0] multiplier;   // 17-bit (includes overlapping bit for Booth)
reg [15:0] product;      // 16-bit product

// Continuous assignment for ready signal
assign rdy = (state == IDLE) && (ctr == 0);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        // Reset state
        state <= IDLE;
        ctr <= 3'b0;
        multiplicand <= { {9{a[7]}}, a };  // 17-bit sign extension
        multiplier <= { {9{b[7]}}, b };   // 17-bit sign extension
        product <= 16'b0;
        p <= 16'b0;
    end
    else begin
        case (state)
            IDLE: begin
                // Start new multiplication
                state <= CALC;
                ctr <= 3'b0;
                multiplicand <= { {9{a[7]}}, a } << 1;  // Pre-shift for Booth
                multiplier <= { {9{b[7]}}, b, 1'b0 };   // Add LSB for Booth
                product <= 16'b0;
            end
            
            CALC: begin
                if (ctr < 4) begin
                    // Booth Radix-4 operation (using 3 bits)
                    case (multiplier[2:0])
                        3'b000, 3'b111: product <= product;              // 0
                        3'b001, 3'b010: product <= product + multiplicand[16:1];  // +1×M
                        3'b011:        product <= product + (multiplicand[16:1] << 1); // +2×M
                        3'b100:        product <= product - (multiplicand[16:1] << 1); // -2×M
                        3'b101, 3'b110: product <= product - multiplicand[16:1];  // -1×M
                    endcase

                    // Arithmetic right shift multiplier by 2 bits
                    multiplier <= { {2{multiplier[16]}}, multiplier[16:2] };

                    // Left shift multiplicand by 2 bits (maintain sign)
                    multiplicand <= { multiplicand[15:0], 2'b0 };

                    ctr <= ctr + 1;
                end
                else begin
                    // Multiplication complete
                    state <= IDLE;
                    p <= product;
                end
            end
        endcase
    end
end

endmodule