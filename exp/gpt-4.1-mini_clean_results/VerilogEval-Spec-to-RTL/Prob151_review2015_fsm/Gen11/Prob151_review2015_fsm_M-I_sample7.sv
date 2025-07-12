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
    localparam S_SEARCH0 = 3'd0,
               S_SEARCH1 = 3'd1,
               S_SEARCH2 = 3'd2,
               S_SEARCH3 = 3'd3,
               S_SHIFT   = 3'd4,
               S_COUNT   = 3'd5,
               S_DONE    = 3'd6;

    reg [2:0] state, next_state;
    reg [1:0] shift_count;

    // State and shift_count register update
    always @(posedge clk) begin
        if (reset) begin
            state <= S_SEARCH0;
            shift_count <= 2'd0;
        end else begin
            state <= next_state;
            if (state == S_SHIFT)
                shift_count <= shift_count + 2'd1;
            else
                shift_count <= 2'd0;
        end
    end

    // Next state logic combinational
    always @(*) begin
        next_state = state; // default hold

        case (state)
            S_SEARCH0: begin
                // Wait for first '1' of the sequence
                if (data == 1'b1)
                    next_state = S_SEARCH1;
                else
                    next_state = S_SEARCH0;
            end
            S_SEARCH1: begin
                // Expect second '1'
                if (data == 1'b1)
                    next_state = S_SEARCH2;
                else
                    next_state = S_SEARCH0;
            end
            S_SEARCH2: begin
                // Expect '0'
                if (data == 1'b0)
                    next_state = S_SEARCH3;
                else if (data == 1'b1)
                    next_state = S_SEARCH2; // stay, pattern overlapping
                else
                    next_state = S_SEARCH0;
            end
            S_SEARCH3: begin
                // Expect final '1' to complete 1101
                if (data == 1'b1)
                    next_state = S_SHIFT;
                else
                    next_state = S_SEARCH0;
            end
            S_SHIFT: begin
                // Shift in 4 bits exactly
                if (shift_count == 2'd3)
                    next_state = S_COUNT;
                else
                    next_state = S_SHIFT;
            end
            S_COUNT: begin
                // Wait for counting done signal
                if (done_counting)
                    next_state = S_DONE;
                else
                    next_state = S_COUNT;
            end
            S_DONE: begin
                // Wait for ack to return to search
                if (ack)
                    next_state = S_SEARCH0;
                else
                    next_state = S_DONE;
            end
            default: next_state = S_SEARCH0;
        endcase
    end

    // Output assignments
    assign shift_ena = (state == S_SHIFT);
    assign counting  = (state == S_COUNT);
    assign done      = (state == S_DONE);

endmodule