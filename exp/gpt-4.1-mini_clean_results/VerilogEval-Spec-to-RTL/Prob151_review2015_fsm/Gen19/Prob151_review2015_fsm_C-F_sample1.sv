module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire data,
    input  wire done_counting,
    input  wire ack,
    output wire shift_ena,
    output wire counting,
    output wire done
);

    // State encoding (3-bit binary)
    localparam [2:0]
        S_SEARCH0 = 3'd0, // Waiting for first '1' of 1101
        S_SEARCH1 = 3'd1, // Matched '1'
        S_SEARCH2 = 3'd2, // Matched '11'
        S_SEARCH3 = 3'd3, // Matched '110'
        S_SHIFT   = 3'd4, // Shift in 4 bits
        S_COUNT   = 3'd5, // Wait counting
        S_DONE    = 3'd6; // Done, wait ack

    reg [2:0] state, next_state;
    reg [3:0] shift_count, next_shift_count; // 4-bit counter for precise 4 cycle count

    // Sequential state and shift_count update with synchronous reset
    always @(posedge clk) begin
        if (reset) begin
            state <= S_SEARCH0;
            shift_count <= 4'd0;
        end else begin
            state <= next_state;
            // Update shift_count only in SHIFT state, else reset to 0
            if (state == S_SHIFT)
                shift_count <= next_shift_count;
            else
                shift_count <= 4'd0;
        end
    end

    // Next state and next shift_count combinational logic
    always @(*) begin
        next_state = state;
        next_shift_count = shift_count;

        case (state)
            S_SEARCH0: begin
                next_state = data ? S_SEARCH1 : S_SEARCH0;
            end
            S_SEARCH1: begin
                next_state = data ? S_SEARCH2 : S_SEARCH0;
            end
            S_SEARCH2: begin
                // If next bit '0', move forward, else stay to catch overlapping patterns
                next_state = (data == 1'b0) ? S_SEARCH3 : S_SEARCH2;
            end
            S_SEARCH3: begin
                next_state = data ? S_SHIFT : S_SEARCH0;
            end
            S_SHIFT: begin
                // Shift in 4 bits: count from 0 to 3
                if (shift_count == 4'd3)
                    next_state = S_COUNT;
                else
                    next_state = S_SHIFT;

                next_shift_count = shift_count + 4'd1;
            end
            S_COUNT: begin
                next_state = done_counting ? S_DONE : S_COUNT;
            end
            S_DONE: begin
                next_state = ack ? S_SEARCH0 : S_DONE;
            end
            default: begin
                next_state = S_SEARCH0;
            end
        endcase
    end

    // Moore style output logic for glitch-free outputs
    assign shift_ena = (state == S_SHIFT);
    assign counting  = (state == S_COUNT);
    assign done      = (state == S_DONE);

endmodule