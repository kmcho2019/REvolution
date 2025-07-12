module multi_booth_8bit (
    input clk,
    input reset,
    input [7:0] a,
    input [7:0] b,
    output reg [15:0] p,
    output reg rdy
);

    reg [2:0] ctr;        // 3-bit counter (0-3)
    reg [15:0] multiplicand;
    reg [8:0] multiplier;  // 8-bit + previous LSB
    reg [15:0] product;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Initialize registers
            multiplicand <= {{8{a[7]}}, a};
            multiplier <= {b, 1'b0};
            product <= 16'b0;
            ctr <= 3'b0;
            rdy <= 1'b0;
        end else if (!rdy) begin
            // Radix-4 Booth encoding
            case (multiplier[2:0])
                3'b000, 3'b111: product <= product;                  // 0
                3'b001, 3'b010: product <= product + multiplicand;    // +1
                3'b011:         product <= product + (multiplicand << 1); // +2
                3'b100:         product <= product - (multiplicand << 1); // -2
                3'b101, 3'b110: product <= product - multiplicand;    // -1
            endcase

            // Arithmetic right shift by 2 bits
            multiplier <= {multiplier[8], multiplier[8], multiplier[8:2]};
            
            // Update counter and ready signal
            ctr <= ctr + 1;
            if (ctr == 3) begin
                p <= product;
                rdy <= 1'b1;
            end
        end
    end

endmodule