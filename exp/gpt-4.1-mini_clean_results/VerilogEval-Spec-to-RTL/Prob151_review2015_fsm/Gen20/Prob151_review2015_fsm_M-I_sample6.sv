module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire data,
    input  wire done_counting,
    input  wire ack,
    output reg  shift_ena,
    output reg  counting,
    output reg  done
);

    // One-hot state encoding for 7 states
    localparam IDLE_BIT   = 0;
    localparam S1_BIT     = 1;
    localparam S11_BIT    = 2;
    localparam S110_BIT   = 3;
    localparam SHIFT_BIT  = 4;
    localparam COUNT_BIT  = 5;
    localparam DONE_BIT   = 6;

    reg [6:0] state, next_state;

    // 2-bit shift counter, update only in SHIFT state (clock gating)
    reg [1:0] shift_count;

    // Sequential logic with synchronous reset
    always @(posedge clk) begin
        if (reset) begin
            state <= 7'b1 << IDLE_BIT; // IDLE state
            shift_count <= 2'b00;
        end else begin
            state <= next_state;
            if (state[SHIFT_BIT])
                shift_count <= shift_count + 1'b1;
            else
                shift_count <= 2'b00;
        end
    end

    // Next state logic and outputs
    always @(*) begin
        // Default output assignments
        shift_ena = 1'b0;
        counting  = 1'b0;
        done      = 1'b0;

        // Default next state is current state (hold)
        next_state = state;

        case (1'b1) // one-hot state decode
            state[IDLE_BIT]: begin
                // pattern start: expect '1'
                next_state = data ? (7'b1 << S1_BIT) : (7'b1 << IDLE_BIT);
            end
            state[S1_BIT]: begin
                // matched '1', expect '1' or '0'
                next_state = data ? (7'b1 << S11_BIT) : (7'b1 << IDLE_BIT);
            end
            state[S11_BIT]: begin
                // matched '11', expect '0' or '1'
                next_state = data ? (7'b1 << S11_BIT) : (7'b1 << S110_BIT);
            end
            state[S110_BIT]: begin
                // matched '110', expect '1' to complete pattern "1101"
                next_state = data ? (7'b1 << SHIFT_BIT) : (7'b1 << IDLE_BIT);
            end
            state[SHIFT_BIT]: begin
                shift_ena = 1'b1;
                if (shift_count == 2'd3)
                    next_state = 7'b1 << COUNT_BIT;
                else
                    next_state = 7'b1 << SHIFT_BIT;
            end
            state[COUNT_BIT]: begin
                counting = 1'b1;
                if (done_counting)
                    next_state = 7'b1 << DONE_BIT;
                else
                    next_state = 7'b1 << COUNT_BIT;
            end
            state[DONE_BIT]: begin
                done = 1'b1;
                if (ack)
                    next_state = 7'b1 << IDLE_BIT;
                else
                    next_state = 7'b1 << DONE_BIT;
            end
            default: begin
                // default to IDLE in unexpected case
                next_state = 7'b1 << IDLE_BIT;
            end
        endcase
    end

endmodule