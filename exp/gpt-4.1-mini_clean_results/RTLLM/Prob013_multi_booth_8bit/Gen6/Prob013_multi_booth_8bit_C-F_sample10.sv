module multi_booth_8bit (
    input             clk,
    input             reset,
    input      [7:0]  a,      // multiplier input
    input      [7:0]  b,      // multiplicand input
    output reg [15:0] p,      // product output
    output reg        rdy      // ready signal
);

    // FSM states
    localparam IDLE = 1'b0;
    localparam BUSY = 1'b1;

    reg state;

    // Signed 16-bit registers for signed arithmetic
    reg signed [15:0] multiplier;     // holds sign-extended multiplier input (a)
    reg signed [15:0] multiplicand;   // holds sign-extended multiplicand input (b)
    reg signed [15:0] product;        // accumulates partial sums

    reg [4:0] ctr;                    // 5-bit counter for 16 iterations

    always @(posedge clk) begin
        if (reset) begin
            // On reset, initialize registers with sign-extended inputs
            multiplier   <= { {8{a[7]}}, a };
            multiplicand <= { {8{b[7]}}, b };
            product      <= 16'sd0;
            ctr          <= 5'd0;
            rdy          <= 1'b0;
            p            <= 16'd0;
            state        <= IDLE;
        end else begin
            case (state)
                IDLE: begin
                    // Start multiplication immediately after reset release
                    rdy <= 1'b0;
                    product <= 16'sd0;
                    ctr <= 5'd0;
                    state <= BUSY;
                end

                BUSY: begin
                    if (ctr < 5'd16) begin
                        // If multiplier bit at current count is 1, add multiplicand to product
                        if (multiplier[ctr]) begin
                            product <= product + multiplicand;
                        end
                        // Shift multiplicand left by 1 for next iteration
                        multiplicand <= multiplicand <<< 1;
                        // Increment counter
                        ctr <= ctr + 1;
                    end else begin
                        // Multiplication done: output result and assert ready
                        p <= product;
                        rdy <= 1'b1;
                        // Hold BUSY state; ready signal stays high until reset
                    end
                end

                default: begin
                    state <= IDLE;
                end
            endcase
        end
    end

endmodule