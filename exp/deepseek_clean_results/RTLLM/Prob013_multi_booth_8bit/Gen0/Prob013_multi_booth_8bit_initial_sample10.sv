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
    reg [4:0] ctr;
    reg [1:0] prev_bit; // Stores previous two bits for Booth encoding

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Initialize registers on reset
            multiplicand <= {{8{b[7]}}, b};
            multiplier <= {{8{a[7]}}, a};
            p <= 16'b0;
            ctr <= 5'b0;
            prev_bit <= 2'b0;
            rdy <= 1'b0;
        end else begin
            if (ctr < 16) begin
                case (multiplier[1:0])
                    2'b01: p <= p + multiplicand;
                    2'b10: p <= p - multiplicand;
                    default: p <= p; // No operation for 00 or 11
                endcase

                // Arithmetic right shift of multiplier
                multiplier <= {multiplier[15], multiplier[15:1]};
                
                // Left shift multiplicand (equivalent to *2)
                multiplicand <= {multiplicand[14:0], 1'b0};
                
                ctr <= ctr + 1;
                rdy <= 1'b0;
            end else begin
                rdy <= 1'b1; // Multiplication complete
            end
        end
    end

endmodule