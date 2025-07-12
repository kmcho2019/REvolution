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

    // State encoding
    localparam [2:0]
        S0      = 3'd0, // No match yet
        S1      = 3'd1, // matched '1'
        S2      = 3'd2, // matched '11'
        S3      = 3'd3, // matched '110'
        SHIFT   = 3'd4, // shifting 4 bits
        COUNT   = 3'd5, // counting in progress
        DONE    = 3'd6; // done, wait ack

    reg [2:0] state, next_state;
    reg [1:0] shift_count; // 4 cycles shift counter

    // Sequential logic: state and shift_count with synchronous active high reset
    always @(posedge clk) begin
        if (reset) begin
            state <= S0;
            shift_count <= 2'd0;
        end else begin
            state <= next_state;

            // Increment shift_count only in SHIFT state, else reset to 0
            if (state == SHIFT)
                shift_count <= shift_count + 2'd1;
            else
                shift_count <= 2'd0;
        end
    end

    // Combinational next state logic - simplified pattern detection and state transitions
    always @(*) begin
        case (state)
            S0: next_state = data ? S1 : S0;

            S1: next_state = data ? S2 : S0;

            S2: next_state = (data == 1'b0) ? S3 : S2;

            S3: next_state = data ? SHIFT : S0;

            SHIFT: next_state = (shift_count == 2'd3) ? COUNT : SHIFT;

            COUNT: next_state = done_counting ? DONE : COUNT;

            DONE: next_state = ack ? S0 : DONE;

            default: next_state = S0;
        endcase
    end

    // Moore outputs: assert based on current state to avoid glitches
    always @(*) begin
        shift_ena = (state == SHIFT);
        counting  = (state == COUNT);
        done      = (state == DONE);
    end

endmodule