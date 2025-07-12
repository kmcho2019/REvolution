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
    typedef enum logic [2:0] {
        SEARCH_0     = 3'd0, // No bits matched yet
        SEARCH_1     = 3'd1, // matched '1'
        SEARCH_11    = 3'd2, // matched '11'
        SEARCH_110   = 3'd3, // matched '110'
        SHIFT_BITS   = 3'd4, // shifting 4 bits to determine delay
        COUNTING     = 3'd5, // waiting for done_counting
        DONE_STATE   = 3'd6  // done asserted, waiting ack
    } state_t;

    state_t state, next_state;

    reg [2:0] shift_count, next_shift_count; // Count 4 shift cycles (0 to 3)

    // State register with synchronous reset
    always @(posedge clk) begin
        if (reset) begin
            state       <= SEARCH_0;
            shift_count <= 3'd0;
        end else begin
            state       <= next_state;
            shift_count <= next_shift_count;
        end
    end

    // Next state and output logic (Moore: outputs depend only on state)
    always @(*) begin
        // Defaults
        next_state      = state;
        next_shift_count= shift_count;

        shift_ena = 1'b0;
        counting  = 1'b0;
        done      = 1'b0;

        case (state)
            // Pattern detection states for "1101"
            SEARCH_0: begin
                // No bits matched yet
                // Check input data to start matching pattern
                if (data == 1'b1)
                    next_state = SEARCH_1;
                else
                    next_state = SEARCH_0;
            end

            SEARCH_1: begin
                // matched '1'
                // Next bit to check
                if (data == 1'b1)
                    next_state = SEARCH_11;
                else
                    next_state = SEARCH_0; // restart
            end

            SEARCH_11: begin
                // matched '11'
                if (data == 1'b0)
                    next_state = SEARCH_110;
                else
                    next_state = SEARCH_11; // stay here if next bit is 1, as overlapping pattern may occur (like 111...)
            end

            SEARCH_110: begin
                // matched '110'
                if (data == 1'b1)
                    next_state = SHIFT_BITS; // pattern 1101 matched
                else if (data == 1'b0)
                    next_state = SEARCH_0; // restart
                else
                    next_state = SEARCH_0;
            end

            SHIFT_BITS: begin
                // assert shift_ena for 4 cycles
                shift_ena = 1'b1;
                if (shift_count == 3'd3) begin
                    next_state      = COUNTING;
                    next_shift_count= 3'd0;
                end else begin
                    next_shift_count= shift_count + 1'b1;
                end
            end

            COUNTING: begin
                counting = 1'b1;
                if (done_counting)
                    next_state = DONE_STATE;
            end

            DONE_STATE: begin
                done = 1'b1;
                if (ack)
                    next_state = SEARCH_0;
            end

            default: begin
                next_state      = SEARCH_0;
                next_shift_count= 3'd0;
            end
        endcase
    end

endmodule