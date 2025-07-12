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

    // One-hot FSM encoding for 7 states
    localparam [6:0]
        SEARCH0 = 7'b0000001, // no bits matched
        SEARCH1 = 7'b0000010, // matched '1'
        SEARCH2 = 7'b0000100, // matched '11'
        SEARCH3 = 7'b0001000, // matched '110'
        SHIFT   = 7'b0010000, // shifting in 4 bits
        COUNT   = 7'b0100000, // counting in progress
        DONE    = 7'b1000000; // done, waiting for ack

    reg [6:0] state, next_state;
    reg [1:0] shift_count; // counts 0..3 for 4 cycles in SHIFT

    // Sequential logic: state and shift_count updates with synchronous reset
    always @(posedge clk) begin
        if (reset) begin
            state <= SEARCH0;
            shift_count <= 2'd0;
        end else begin
            state <= next_state;
            if (state == SHIFT)
                shift_count <= shift_count + 2'd1;
            else
                shift_count <= 2'd0;
        end
    end

    // Next state logic (one-hot encoded) with embedded pattern detection and overlapping support
    always @(*) begin
        // Default next_state = current state to avoid latches
        next_state = 7'b0;

        case (1'b1) // one-hot decoding style
            state[0]: begin // SEARCH0
                // data==1 -> SEARCH1 else remain SEARCH0
                next_state = data ? SEARCH1 : SEARCH0;
            end

            state[1]: begin // SEARCH1 (matched '1')
                // data==1 -> SEARCH2 else SEARCH0
                next_state = data ? SEARCH2 : SEARCH0;
            end

            state[2]: begin // SEARCH2 (matched '11')
                // data==0 -> SEARCH3 else remain SEARCH2 for overlapping '1's
                next_state = (~data) ? SEARCH3 : SEARCH2;
            end

            state[3]: begin // SEARCH3 (matched '110')
                // data==1 -> SHIFT else SEARCH0
                next_state = data ? SHIFT : SEARCH0;
            end

            state[4]: begin // SHIFT (shifting 4 bits)
                // after 4 cycles (shift_count == 3) -> COUNT else remain SHIFT
                next_state = (shift_count == 2'd3) ? COUNT : SHIFT;
            end

            state[5]: begin // COUNT (waiting done_counting)
                // done_counting -> DONE else remain COUNT
                next_state = done_counting ? DONE : COUNT;
            end

            state[6]: begin // DONE (waiting ack)
                // ack -> SEARCH0 else remain DONE
                next_state = ack ? SEARCH0 : DONE;
            end

            default: next_state = SEARCH0; // safe default
        endcase
    end

    // Moore outputs purely from current one-hot state for minimal glitches
    always @(*) begin
        shift_ena = (state == SHIFT);
        counting  = (state == COUNT);
        done      = (state == DONE);
    end

endmodule