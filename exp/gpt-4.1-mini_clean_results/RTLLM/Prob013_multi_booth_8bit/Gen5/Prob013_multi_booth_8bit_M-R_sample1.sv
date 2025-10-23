module multi_booth_8bit (
    input             clk,
    input             reset,
    input      [7:0]  a,        // multiplier input
    input      [7:0]  b,        // multiplicand input
    output reg [15:0] p,        // product output
    output reg        rdy        // ready signal
);

    // State encoding
    localparam IDLE = 1'b0;
    localparam BUSY = 1'b1;

    reg state;

    // Signed registers for arithmetic
    reg signed [15:0] multiplier;     // holds multiplier sign-extended input
    reg signed [15:0] multiplicand;   // holds multiplicand sign-extended input
    reg signed [15:0] product;        // accumulates partial sums

    reg [4:0] ctr;                    // 5-bit counter from 0 to 16

    always @(posedge clk) begin
        if (reset) begin
            // Load inputs sign-extended
            multiplier   <= { {8{a[7]}}, a };   // multiplier <= sign-extended 'a'
            multiplicand <= { {8{b[7]}}, b };   // multiplicand <= sign-extended 'b'
            product      <= 16'sd0;
            ctr          <= 5'd0;
            rdy          <= 1'b0;
            state        <= IDLE;
            p            <= 16'd0;
        end else begin
            case (state)
                IDLE: begin
                    // Start multiplication immediately after reset release
                    rdy <= 1'b0;
                    ctr <= 5'd0;
                    product <= 16'sd0;
                    // stay ready till process started
                    // Move to BUSY to start processing
                    state <= BUSY;
                end

                BUSY: begin
                    if (ctr < 5'd16) begin
                        // Check multiplier bit ctr
                        if (multiplier[ctr]) begin
                            // Add multiplicand to product
                            product <= product + multiplicand;
                        end
                        // Shift multiplicand left by 1 bit for next cycle
                        multiplicand <= multiplicand <<< 1;

                        // Increment counter
                        ctr <= ctr + 1'b1;
                    end else begin
                        // Multiplication done
                        p <= product; // update output product
                        rdy <= 1'b1;
                        // Stay in BUSY with rdy asserted until reset
                    end
                end

                default: begin
                    // safety fallback
                    state <= IDLE;
                end
            endcase
        end
    end

endmodule