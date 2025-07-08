module multi_booth_8bit (
    input        clk,
    input        reset,
    input  [7:0] a,
    input  [7:0] b,
    output reg [15:0] p,
    output reg        rdy
);

    reg [15:0] multiplicand;
    reg [15:0] multiplier;
    reg [4:0]  ctr;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Sign-extend inputs to 16 bits
            multiplicand <= {{8{b[7]}}, b};
            multiplier   <= {{8{a[7]}}, a};
            p            <= 16'd0;
            ctr          <= 5'd0;
            rdy          <= 1'b0;
        end else begin
            if (ctr < 16) begin
                // If current multiplier bit is 1, add multiplicand to product
                if (multiplier[ctr] == 1'b1)
                    p <= p + multiplicand;

                // Shift multiplicand left by 1 for next bit
                multiplicand <= multiplicand << 1;

                // Increment counter
                ctr <= ctr + 1'b1;
            end else begin
                rdy <= 1'b1; // Multiplication complete
            end
        end
    end

endmodule