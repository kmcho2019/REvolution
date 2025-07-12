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

    reg state, next_state;
    reg signed [15:0] multiplier;    // sign-extended multiplier
    reg signed [15:0] multiplicand;  // sign-extended multiplicand
    reg [4:0] ctr;

    // Next state logic
    always @(*) begin
        case(state)
            IDLE: begin
                if (!rdy) 
                    next_state = BUSY; // start multiplication when not ready (new inputs)
                else
                    next_state = IDLE;
            end
            BUSY: begin
                if (ctr == 5'd16)
                    next_state = IDLE;
                else
                    next_state = BUSY;
            end
            default: next_state = IDLE;
        endcase
    end

    // Sequential logic
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state       <= IDLE;
            multiplier  <= { {8{a[7]}}, a };
            multiplicand<= { {8{b[7]}}, b };
            p           <= 16'sd0;
            ctr         <= 5'd0;
            rdy         <= 1'b0;
        end else begin
            state <= next_state;

            case(state)
                IDLE: begin
                    // Load operands and clear signals only when transitioning from BUSY to IDLE (multiplication done)
                    if (next_state == BUSY) begin
                        multiplier   <= { {8{a[7]}}, a };
                        multiplicand <= { {8{b[7]}}, b };
                        p            <= 16'sd0;
                        ctr          <= 5'd0;
                        rdy          <= 1'b0;
                    end else begin
                        rdy <= 1'b1; // maintain ready when idle
                    end
                end
                BUSY: begin
                    // Process current multiplier bit
                    if (multiplier[ctr]) begin
                        p <= p + multiplicand;
                    end
                    multiplicand <= multiplicand <<< 1;
                    ctr <= ctr + 1;
                    if (ctr == 5'd15) begin
                        rdy <= 1'b1; // multiplication complete after 16 cycles
                    end
                end
            endcase
        end
    end

endmodule