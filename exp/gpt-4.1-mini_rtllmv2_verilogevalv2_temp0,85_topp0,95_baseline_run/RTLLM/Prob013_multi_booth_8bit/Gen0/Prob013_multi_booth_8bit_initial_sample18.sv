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

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // On reset, load multiplicand and multiplier with sign-extension
            multiplicand <= {{8{a[7]}}, a};
            multiplier   <= {{8{b[7]}}, b};
            p            <= 16'b0;
            ctr          <= 0;
            rdy          <= 0;
        end else begin
            if (ctr < 16) begin
                // If multiplier bit at ctr is 1, accumulate multiplicand
                if (multiplier[ctr])
                    p <= p + multiplicand;
                // Shift multiplicand left by 1
                multiplicand <= multiplicand << 1;
                ctr <= ctr + 1;
            end else begin
                // Multiplication done
                rdy <= 1;
            end
        end
    end

endmodule