module multi_booth_8bit (
    input             clk,
    input             reset,
    input      [7:0]  a,      // multiplicand
    input      [7:0]  b,      // multiplier
    output reg [15:0] p,      // product
    output reg        rdy      // ready signal
);

    // State encoding
    typedef enum logic [0:0] {IDLE=1'b0, RUN=1'b1} state_t;
    state_t state, next_state;

    reg [4:0] ctr;                  // 5-bit counter (0 to 15)
    reg signed [15:0] multiplicand_shifted;
    reg [15:0] multiplier_ext;     // 16-bit sign-extended multiplier

    // State register
    always @(posedge clk) begin
        if (reset)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Next state logic
    always @(*) begin
        case (state)
            IDLE: next_state = RUN;
            RUN:  next_state = (ctr == 5'd16) ? IDLE : RUN;
            default: next_state = IDLE;
        endcase
    end

    // Counter and registers update
    always @(posedge clk) begin
        if (reset) begin
            // Initialize registers and outputs
            p <= 16'd0;
            rdy <= 1'b0;
            ctr <= 5'd0;
            multiplicand_shifted <= { {8{a[7]}}, a };   // sign-extended multiplicand
            multiplier_ext <= { {8{b[7]}}, b };         // sign-extended multiplier
        end else begin
            case (state)
                IDLE: begin
                    p <= 16'd0;
                    rdy <= 1'b0;
                    ctr <= 5'd0;
                    multiplicand_shifted <= { {8{a[7]}}, a };
                    multiplier_ext <= { {8{b[7]}}, b };
                end
                RUN: begin
                    if (ctr < 5'd16) begin
                        // If current multiplier bit is 1, add multiplicand_shifted to product
                        if (multiplier_ext[ctr] == 1'b1)
                            p <= p + multiplicand_shifted;
                        else
                            p <= p;  // no change
                        // Shift multiplicand_shifted left by 1
                        multiplicand_shifted <= multiplicand_shifted <<< 1;
                        // Increment counter
                        ctr <= ctr + 1'b1;
                        rdy <= 1'b0;
                    end else begin
                        // Done multiplication
                        rdy <= 1'b1;
                        // Hold values
                        p <= p;
                        multiplicand_shifted <= multiplicand_shifted;
                        ctr <= ctr;
                    end
                end
                default: begin
                    p <= 16'd0;
                    rdy <= 1'b0;
                    ctr <= 5'd0;
                    multiplicand_shifted <= 16'sd0;
                    multiplier_ext <= 16'd0;
                end
            endcase
        end
    end

endmodule