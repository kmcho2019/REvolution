module TopModule (
    input  logic clk,
    input  logic reset,
    input  logic data,
    input  logic done_counting,
    input  logic ack,
    output logic shift_ena,
    output logic counting,
    output logic done
);

    // State encoding using typedef enum for clarity and type safety
    typedef enum logic [2:0] {
        SEARCH0 = 3'd0, // no bits matched
        SEARCH1 = 3'd1, // matched '1'
        SEARCH2 = 3'd2, // matched '11'
        SEARCH3 = 3'd3, // matched '110'
        SHIFT   = 3'd4, // shifting in 4 bits
        COUNT   = 3'd5, // waiting for counting to finish
        DONE    = 3'd6  // done, waiting for ack
    } state_t;

    state_t state, next_state;

    // 2-bit counter for counting shift cycles (0 to 3)
    logic [1:0] shift_count;

    // Sequential logic: state and shift_count update with synchronous reset
    always_ff @(posedge clk) begin
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

    // Next state combinational logic
    always_comb begin
        // Default next state is hold state
        next_state = state;

        case (state)
            SEARCH0: next_state = (data) ? SEARCH1 : SEARCH0;
            SEARCH1: next_state = (data) ? SEARCH2 : SEARCH0;
            SEARCH2: next_state = (~data) ? SEARCH3 : SEARCH2; // allow overlapping pattern detection
            SEARCH3: next_state = (data) ? SHIFT : SEARCH0;
            SHIFT:   next_state = (shift_count == 2'd3) ? COUNT : SHIFT;
            COUNT:   next_state = (done_counting) ? DONE : COUNT;
            DONE:    next_state = (ack) ? SEARCH0 : DONE;
            default: next_state = SEARCH0;
        endcase
    end

    // Outputs combinationally driven as Moore FSM outputs
    always_comb begin
        shift_ena = (state == SHIFT);
        counting  = (state == COUNT);
        done      = (state == DONE);
    end

endmodule