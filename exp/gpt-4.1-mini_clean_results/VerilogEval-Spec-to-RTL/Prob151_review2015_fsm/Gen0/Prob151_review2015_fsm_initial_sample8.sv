module TopModule (
    input clk,
    input reset,
    input data,
    input done_counting,
    input ack,
    output reg shift_ena,
    output reg counting,
    output reg done
);

    // State encoding
    typedef enum logic [1:0] {
        S_SEARCH  = 2'd0,
        S_SHIFT   = 2'd1,
        S_COUNT   = 2'd2,
        S_DONE    = 2'd3
    } state_t;

    state_t state, next_state;

    reg [3:0] shift_reg;       // to detect pattern 1101
    reg [2:0] shift_count;     // count 4 cycles of shifting during S_SHIFT

    // Pattern to detect: 1101 = 4'b1101
    localparam [3:0] PATTERN = 4'b1101;

    // Sequential logic
    always @(posedge clk) begin
        if (reset) begin
            state <= S_SEARCH;
            shift_reg <= 4'b0;
            shift_count <= 3'd0;
        end else begin
            state <= next_state;
            case (state)
                S_SEARCH: begin
                    // shift in data to shift_reg to detect pattern
                    shift_reg <= {shift_reg[2:0], data};
                end
                S_SHIFT: begin
                    // shift 4 cycles, enable shift_ena
                    shift_count <= shift_count + 1;
                end
                S_COUNT: begin
                    // nothing to do here sequentially for this FSM
                end
                S_DONE: begin
                    // nothing to do here sequentially for this FSM
                end
            endcase
        end
    end

    // Next state logic
    always @(*) begin
        // Default next state is current state
        next_state = state;

        case(state)
            S_SEARCH: begin
                if (shift_reg == PATTERN) begin
                    next_state = S_SHIFT;
                end
            end
            S_SHIFT: begin
                if (shift_count == 3'd3) begin
                    next_state = S_COUNT;
                end
            end
            S_COUNT: begin
                if (done_counting) begin
                    next_state = S_DONE;
                end
            end
            S_DONE: begin
                if (ack) begin
                    next_state = S_SEARCH;
                end
            end
        endcase
    end

    // Output logic
    always @(*) begin
        // Default outputs
        shift_ena = 1'b0;
        counting  = 1'b0;
        done      = 1'b0;

        case(state)
            S_SEARCH: begin
                // nothing asserted
            end
            S_SHIFT: begin
                shift_ena = 1'b1;
            end
            S_COUNT: begin
                counting = 1'b1;
            end
            S_DONE: begin
                done = 1'b1;
            end
        endcase
    end

endmodule