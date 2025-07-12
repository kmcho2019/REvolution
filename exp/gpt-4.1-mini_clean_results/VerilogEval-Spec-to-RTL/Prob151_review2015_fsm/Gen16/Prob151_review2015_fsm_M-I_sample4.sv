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

    // One-hot encoding for 7 states (7 flip-flops)
    localparam [6:0]
        SEARCH0 = 7'b000_0001, // no bits matched
        SEARCH1 = 7'b000_0010, // matched '1'
        SEARCH2 = 7'b000_0100, // matched '11'
        SEARCH3 = 7'b000_1000, // matched '110'
        SHIFT   = 7'b001_0000, // shifting in 4 bits
        COUNT   = 7'b010_0000, // counting in progress
        DONE    = 7'b100_0000; // done, waiting for ack

    reg [6:0] state, next_state;

    // 4-cycle shift counter: a single hot bit shifted right each cycle in SHIFT state
    // Initialized to 4'b1000; after 4 shifts counter == 0
    reg [3:0] shift_counter;

    // Sequential logic: state and shift_counter registers, synchronous active-high reset
    always @(posedge clk) begin
        if (reset) begin
            state <= SEARCH0;
            shift_counter <= 4'b0000;
        end else begin
            state <= next_state;

            // shift_counter control
            if (state == SHIFT) begin
                // shift right by 1; if zero, reload 4'b1000 at SHIFT start
                if (shift_counter == 4'b0000)
                    shift_counter <= 4'b1000;
                else
                    shift_counter <= shift_counter >> 1;
            end else begin
                shift_counter <= 4'b0000;
            end
        end
    end

    // Combinational next-state logic based on one-hot current state and inputs
    always @(*) begin
        // Default next state keeps current state
        next_state = state;

        case (1'b1) // one-hot state encoding

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
                    next_state = SEARCH2;
            end

            state[3]: begin // SEARCH3
                if (data)
                    next_state = SHIFT;
                else
                    next_state = SEARCH0;
            end

            state[4]: begin // SHIFT
                if (shift_counter == 4'b0001) // after shifting 3 times, next is last cycle
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

    // Registered outputs to reduce glitches and switching activity
    always @(posedge clk) begin
        if (reset) begin
            shift_ena <= 1'b0;
            counting  <= 1'b0;
            done      <= 1'b0;
        end else begin
            shift_ena <= (state == SHIFT);
            counting  <= (state == COUNT);
            done      <= (state == DONE);
        end
    end

endmodule