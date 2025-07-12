module multi_booth_8bit (
    input           clk,
    input           reset,
    input  [7:0]    a,  // multiplicand
    input  [7:0]    b,  // multiplier
    output reg [15:0] p, // product
    output reg      rdy
);

    reg signed [15:0] multiplicand;
    reg signed [15:0] multiplier;
    reg [4:0]         ctr;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Sign-extend inputs
            multiplicand <= { {8{a[7]}}, a };
            multiplier   <= { {8{b[7]}}, b };
            p            <= 16'sd0;
            ctr          <= 5'd0;
            rdy          <= 1'b0;
        end else if (!rdy) begin
            if (ctr < 5'd16) begin
                // Add multiplicand to product if current multiplier bit is 1
                if (multiplier[ctr])
                    p <= p + multiplicand;
                // Shift multiplicand left by 1 for next cycle
                multiplicand <= multiplicand <<< 1;
                ctr <= ctr + 1;
            end else begin
                rdy <= 1'b1; // multiplication complete
            end
        end
    end

endmodule