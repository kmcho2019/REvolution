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
    reg [15:0] product;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Initialize registers
            multiplicand <= {{8{a[7]}}, a};
            multiplier <= {{8{b[7]}}, b};
            product <= 16'b0;
            ctr <= 5'b0;
            rdy <= 1'b0;
        end else begin
            if (ctr < 8) begin
                // Process current 2-bit group
                case (multiplier[1:0])
                    2'b01: product <= product + (multiplicand << (ctr*2));
                    2'b10: product <= product - (multiplicand << (ctr*2));
                    2'b11: product <= product - (multiplicand << (ctr*2 + 1));
                    default: product <= product; // 00 does nothing
                endcase
                
                // Shift multiplier right by 2 bits for next group
                multiplier <= multiplier >> 2;
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