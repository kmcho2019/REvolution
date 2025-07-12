module multi_booth_8bit (
    input              clk,
    input              reset,
    input      [7:0]   a,    // multiplier input
    input      [7:0]   b,    // multiplicand input
    output reg [15:0]  p,    // product output
    output reg         rdy    // ready signal
);

    // Declare signed registers for proper signed operations
    reg signed [15:0] multiplier;
    reg signed [15:0] multiplicand;
    reg [4:0]         ctr;

    always @(posedge clk) begin
        if (reset) begin
            // Sign-extend inputs
            multiplier   <= { {8{a[7]}}, a };
            multiplicand <= { {8{b[7]}}, b };
            p            <= 16'sd0;
            ctr          <= 5'd0;
            rdy          <= 1'b0;
        end else if (!rdy) begin
            if (ctr < 5'd16) begin
                // If current multiplier bit is 1, add multiplicand to product
                if (multiplier[ctr]) begin
                    p <= p + multiplicand;
                end
                // Shift multiplicand left for next bit
                multiplicand <= multiplicand <<< 1;
                // Increment counter
                ctr <= ctr + 1;
            end else begin
                rdy <= 1'b1; // multiplication done
            end
        end
    end

endmodule