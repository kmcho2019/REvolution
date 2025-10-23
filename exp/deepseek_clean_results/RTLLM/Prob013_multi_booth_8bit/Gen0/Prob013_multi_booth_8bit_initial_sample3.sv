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
    reg [3:0] ctr;
    reg [1:0] prev_bit; // Stores previous bit for Booth encoding

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Initialize registers
            multiplicand <= {{8{a[7]}}, a};
            multiplier <= {{8{b[7]}}, b};
            p <= 16'b0;
            ctr <= 4'b0;
            prev_bit <= 2'b0;
            rdy <= 1'b0;
        end else begin
            if (ctr < 4) begin
                // Booth Radix-4 encoding
                case (multiplier[1:0])
                    2'b00: begin
                        // No operation
                        p <= p;
                    end
                    2'b01: begin
                        // Add multiplicand
                        p <= p + (multiplicand << (2*ctr));
                    end
                    2'b10: begin
                        // Subtract multiplicand
                        p <= p - (multiplicand << (2*ctr));
                    end
                    2'b11: begin
                        // No operation (treated as 00 in next step)
                        p <= p;
                    end
                endcase

                // Shift multiplier right by 2 bits for next step
                multiplier <= multiplier >> 2;
                ctr <= ctr + 1;
                rdy <= 1'b0;
            end else begin
                // Multiplication complete
                rdy <= 1'b1;
            end
        end
    end

endmodule