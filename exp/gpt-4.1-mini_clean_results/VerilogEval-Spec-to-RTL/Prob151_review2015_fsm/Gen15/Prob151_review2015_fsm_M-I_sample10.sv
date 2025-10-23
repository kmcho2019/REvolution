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

    // One-hot encoded states
    typedef enum logic [6:0] {
        SEARCH0 = 7'b0000001, // no pattern bits matched
        SEARCH1 = 7'b0000010, // matched '1'
        SEARCH2 = 7'b0000100, // matched '11'
        SEARCH3 = 7'b0001000, // matched '110'
        SHIFT   = 7'b0010000, // shifting delay bits (4 cycles)
        COUNT   = 7'b0100000, // counting delay
        DONE    = 7'b1000000  // done, waiting for ack
    } state_t;

    state_t state, next_state;

    // Shift count counter: count 0 to 3 for 4 shift cycles
    reg [1:0] shift_count;

    // Sequential logic: state and shift_count with synchronous reset
    always_ff @(posedge clk) begin
        if (reset) begin
            state <= SEARCH0;
            shift_count <= 2'b00;
        end else begin
            state <= next_state;
            if (state == SHIFT) begin
                shift_count <= shift_count + 2'b01;
            end else begin
                shift_count <= 2'b00;
            end
        end
    end

    // Next state logic (one-hot FSM)
    always_comb begin
        next_state = 7'd0; // default to zero to avoid latches
        case (1'b1)
            state[0]: begin // SEARCH0
                if (data)
                    next_state = SEARCH1;
                else
                    next_state = SEARCH0;
            end
            state[1]: begin // SEARCH1
                if (data)
                    next_state = SEARCH2;
                else
                    next_state = SEARCH0;
            end
            state[2]: begin // SEARCH2
                if (~data)
                    next_state = SEARCH3;
                else
                    next_state = SEARCH2; // remain for overlapping pattern
            end
            state[3]: begin // SEARCH3
                if (data)
                    next_state = SHIFT;
                else
                    next_state = SEARCH0;
            end
            state[4]: begin // SHIFT
                if (shift_count == 2'd3)
                    next_state = COUNT;
                else
                    next_state = SHIFT;
            end
            state[5]: begin // COUNT
                if (done_counting)
                    next_state = DONE;
                else
                    next_state = COUNT;
            end
            state[6]: begin // DONE
                if (ack)
                    next_state = SEARCH0;
                else
                    next_state = DONE;
            end
            default: next_state = SEARCH0;
        endcase
    end

    // Outputs: Moore FSM style
    always_comb begin
        shift_ena = (state == SHIFT);
        counting  = (state == COUNT);
        done      = (state == DONE);
    end

endmodule