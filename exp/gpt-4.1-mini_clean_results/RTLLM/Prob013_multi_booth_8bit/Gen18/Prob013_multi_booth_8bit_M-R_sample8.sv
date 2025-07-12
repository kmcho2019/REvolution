module multi_booth_8bit (
    input             clk,
    input             reset,
    input      [7:0]  a,
    input      [7:0]  b,
    output reg [15:0] p,
    output reg        rdy
);

    // FSM states
    typedef enum reg [1:0] {
        IDLE = 2'b00,
        BUSY = 2'b01,
        DONE = 2'b10
    } state_t;

    reg signed [15:0] multiplier;
    reg signed [15:0] multiplicand;
    reg [4:0]         ctr;
    reg state_t        state;

    always @(posedge clk) begin
        if (reset) begin
            // Initialize all registers and go to IDLE state
            multiplier   <= 16'sd0;
            multiplicand <= 16'sd0;
            p            <= 16'sd0;
            ctr          <= 5'd0;
            rdy          <= 1'b0;
            state        <= IDLE;
        end else begin
            case (state)
                IDLE: begin
                    rdy <= 1'b0;
                    // Latch inputs and start multiplication
                    multiplier   <= { {8{a[7]}}, a };
                    multiplicand <= { {8{b[7]}}, b };
                    p            <= 16'sd0;
                    ctr          <= 5'd0;
                    state        <= BUSY;
                end
                BUSY: begin
                    // If current multiplier bit is 1, add multiplicand to product
                    if (multiplier[ctr])
                        p <= p + multiplicand;
                    // Shift multiplicand left by 1
                    multiplicand <= multiplicand <<< 1;
                    ctr <= ctr + 1;
                    if (ctr == 5'd15) begin
                        // Last cycle, move to DONE
                        state <= DONE;
                        rdy <= 1'b1;
                    end
                end
                DONE: begin
                    // Remain in DONE state; product and ready hold stable
                    rdy <= 1'b1;
                end
                default: state <= IDLE;
            endcase
        end
    end

endmodule