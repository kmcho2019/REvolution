module multi_booth_8bit (
    input clk,
    input reset,
    input [7:0] a,
    input [7:0] b,
    output reg [15:0] p,
    output reg rdy
);

    reg [15:0] multiplicand;
    reg [15:0] multiplier;
    reg [2:0] ctr;      // Counter (0-4)
    reg prev_bit;       // Previous bit for Booth encoding

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Initialize with sign extension
            multiplicand <= {{8{a[7]}}, a};
            multiplier <= {{8{b[7]}}, b};
            p <= 16'b0;
            ctr <= 3'b0;
            rdy <= 1'b0;
            prev_bit <= 1'b0;
        end else begin
            if (ctr < 4) begin
                // Booth encoding and operation
                case ({multiplier[1:0], prev_bit})
                    3'b000, 3'b111: p <= p;             // No operation
                    3'b001, 3'b010: p <= p + multiplicand;  // +1×
                    3'b011: p <= p + (multiplicand << 1);   // +2×
                    3'b100: p <= p - (multiplicand << 1);   // -2×
                    3'b101, 3'b110: p <= p - multiplicand;  // -1×
                endcase

                // Arithmetic right shift multiplier by 2
                multiplier <= { {2{multiplier[15]}}, multiplier[15:2] };
                // Left shift multiplicand by 2
                multiplicand <= multiplicand << 2;
                // Store previous bit
                prev_bit <= multiplier[1];

                ctr <= ctr + 1;
                rdy <= (ctr == 3);  // Set ready when counter will be 4 next cycle
            end else begin
                rdy <= 1'b1;        // Maintain ready signal
            end
        end
    end

endmodule