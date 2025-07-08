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
    reg [4:0] ctr; // 5-bit counter, counts to 16

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Sign-extend inputs and initialize
            multiplier   <= {{8{a[7]}}, a};
            multiplicand <= {{8{b[7]}}, b};
            p            <= 16'b0;
            ctr          <= 5'b0;
            rdy          <= 1'b0;
        end else if (ctr < 16) begin
            // Shift multiplicand left by 1
            multiplicand <= multiplicand << 1;

            // If current bit of multiplier is 1, add multiplicand to product
            if (multiplier[ctr] == 1'b1)
                p <= p + multiplicand;
            else
                p <= p;

            // Increment counter
            ctr <= ctr + 1'b1;

            // When counter reaches 16, set ready
            if (ctr + 1 == 16)
                rdy <= 1'b1;
        end
    end

endmodule