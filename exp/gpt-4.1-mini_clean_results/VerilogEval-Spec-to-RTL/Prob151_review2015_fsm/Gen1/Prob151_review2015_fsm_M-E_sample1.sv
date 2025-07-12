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

    // States encoding
    typedef enum logic [2:0] {
        SEARCH0 = 3'd0, // no match yet
        SEARCH1 = 3'd1, // matched '1'
        SEARCH2 = 3'd2, // matched '11'
        SEARCH3 = 3'd3, // matched '110'
        SHIFT   = 3'd4, // shifting delay bits (4 cycles)
        COUNT   = 3'd5, // counting delay
        DONE    = 3'd6  // done, waiting for ack
    } state_t;

    state_t state, next_state;

    // Counter for SHIFT cycles (0 to 3)
    reg [1:0] shift_count;

    // State register with synchronous reset
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

    // Next state logic with pattern detection via states (Moore FSM)
    always @(*) begin
        // default next state is current state (hold)
        next_state = state;
        case (state)
            SEARCH0: begin
                // pattern start: first bit '1'
                if (data)
                    next_state = SEARCH1;
                else
                    next_state = SEARCH0;
            end
            SEARCH1: begin
                // matched '1', next bit '1' => '11'
                if (data)
                    next_state = SEARCH2;
                else
                    next_state = SEARCH0;
            end
            SEARCH2: begin
                // matched '11', next bit '0' => '110'
                if (~data)
                    next_state = SEARCH3;
                else
                    next_state = SEARCH2; // still matched '11' because next input is '1'
            end
            SEARCH3: begin
                // matched '110', next bit '1' => full pattern '1101'
                if (data)
                    next_state = SHIFT;
                else if (~data)
                    next_state = SEARCH0; // pattern failed, restart search
                else
                    next_state = SEARCH0;
            end
            SHIFT: begin
                // count 4 cycles
                if (shift_count == 2'd3) // after 4 clocks (0,1,2,3)
                    next_state = COUNT;
                else
                    next_state = SHIFT;
            end
            COUNT: begin
                if (done_counting)
                    next_state = DONE;
                else
                    next_state = COUNT;
            end
            DONE: begin
                if (ack)
                    next_state = SEARCH0;
                else
                    next_state = DONE;
            end
            default: next_state = SEARCH0;
        endcase
    end

    // Outputs combinationally assigned based on state
    always @(*) begin
        shift_ena = (state == SHIFT);
        counting  = (state == COUNT);
        done      = (state == DONE);
    end

endmodule