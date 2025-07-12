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

    // State encoding (binary)
    typedef enum logic [2:0] {
        SEARCH0 = 3'd0, // no pattern bits matched
        SEARCH1 = 3'd1, // matched '1'
        SEARCH2 = 3'd2, // matched '11'
        SEARCH3 = 3'd3, // matched '110'
        SHIFT   = 3'd4, // shifting delay bits (4 cycles)
        COUNT   = 3'd5, // counting delay
        DONE    = 3'd6  // done, waiting for ack
    } state_t;

    state_t state, next_state;

    // 2-bit counter for shift cycles (0 to 3)
    reg [1:0] shift_count;

    // Sequential logic: state and shift_count update with synchronous reset
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

    // Next state combinational logic (Moore FSM)
    always @(*) begin
        next_state = state;
        case (state)
            SEARCH0: begin
                // Wait for first '1' of pattern
                if (data)
                    next_state = SEARCH1;
                else
                    next_state = SEARCH0;
            end
            SEARCH1: begin
                // Matched '1', expect another '1'
                if (data)
                    next_state = SEARCH2;
                else
                    next_state = SEARCH0;
            end
            SEARCH2: begin
                // Matched '11', expect '0'
                if (~data)
                    next_state = SEARCH3;
                else
                    next_state = SEARCH2; // remain in SEARCH2 on '1' for overlapping pattern
            end
            SEARCH3: begin
                // Matched '110', expect final '1'
                if (data)
                    next_state = SHIFT;
                else
                    next_state = SEARCH0;
            end
            SHIFT: begin
                // Assert shift_ena 4 cycles, then move to COUNT
                if (shift_count == 2'd3)
                    next_state = COUNT;
                else
                    next_state = SHIFT;
            end
            COUNT: begin
                // Wait for done_counting signal
                if (done_counting)
                    next_state = DONE;
                else
                    next_state = COUNT;
            end
            DONE: begin
                // Assert done until ack received, then restart search
                if (ack)
                    next_state = SEARCH0;
                else
                    next_state = DONE;
            end
            default: next_state = SEARCH0;
        endcase
    end

    // Outputs combinationally driven by current state (Moore outputs)
    always @(*) begin
        shift_ena = (state == SHIFT);
        counting  = (state == COUNT);
        done      = (state == DONE);
    end

endmodule