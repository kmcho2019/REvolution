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
        S0_IDLE  = 3'd0, // waiting for '1'
        S1_1     = 3'd1, // matched '1'
        S2_11    = 3'd2, // matched '11'
        S3_110   = 3'd3, // matched '110'
        S4_SHIFT = 3'd4, // shifting 4 bits (shift_ena)
        S5_COUNT = 3'd5, // waiting for done_counting
        S6_DONE  = 3'd6; // done asserted, wait for ack

    reg [2:0] state, next_state;
    reg [2:0] shift_count; // counts 0..3 for 4 cycles shift_ena asserted

    // State register and shift_count
    always @(posedge clk) begin
        if (reset) begin
            state <= S0_IDLE;
            shift_count <= 3'd0;
        end else begin
            state <= next_state;
            // shift_count increments only in SHIFT state
            if (state == S4_SHIFT)
                shift_count <= shift_count + 3'd1;
            else
                shift_count <= 3'd0;
        end
    end

    // Next state logic with integrated pattern detection as Mealy transitions
    always @(*) begin
        // Default assignments
        next_state = state;

        case(state)
            S0_IDLE: begin
                // Looking for first '1'
                if (data == 1'b1)
                    next_state = S1_1;
                else
                    next_state = S0_IDLE;
            end

            S1_1: begin
                // Pattern so far: 1
                if (data == 1'b1)
                    next_state = S2_11;
                else
                    next_state = S0_IDLE; // mismatch, restart
            end

            S2_11: begin
                // Pattern so far: 11
                if (data == 1'b0)
                    next_state = S3_110;
                else if (data == 1'b1)
                    // overlapping pattern, remain in S2_11 (matched 11 again)
                    next_state = S2_11;
                else
                    next_state = S0_IDLE;
            end

            S3_110: begin
                // Pattern so far: 110
                if (data == 1'b1)
                    // pattern 1101 matched!
                    next_state = S4_SHIFT;
                else if (data == 1'b0)
                    // '0' after 110 breaks pattern, restart or check partial
                    next_state = S0_IDLE;
                else
                    next_state = S0_IDLE;
            end

            S4_SHIFT: begin
                // Assert shift_ena for exactly 4 cycles (shift_count 0..3)
                if (shift_count == 3'd3)
                    next_state = S5_COUNT;
                else
                    next_state = S4_SHIFT;
            end

            S5_COUNT: begin
                if (done_counting)
                    next_state = S6_DONE;
                else
                    next_state = S5_COUNT;
            end

            S6_DONE: begin
                if (ack)
                    next_state = S0_IDLE;
                else
                    next_state = S6_DONE;
            end

            default: next_state = S0_IDLE;
        endcase
    end

    // Output logic (Mealy where useful)
    always @(*) begin
        // Default outputs
        shift_ena = 1'b0;
        counting  = 1'b0;
        done      = 1'b0;

        case(state)
            S4_SHIFT: begin
                // shift_ena asserted for 4 cycles
                shift_ena = 1'b1;
            end
            S5_COUNT: begin
                counting = 1'b1;
            end
            S6_DONE: begin
                done = 1'b1;
            end
            default: ;
        endcase
    end

endmodule