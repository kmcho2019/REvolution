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

    // Binary-encoded states (3-bit)
    localparam S_SEARCH0 = 3'd0, // no bits matched yet
               S_SEARCH1 = 3'd1, // matched '1'
               S_SEARCH2 = 3'd2, // matched '11'
               S_SEARCH3 = 3'd3, // matched '110'
               S_SHIFT   = 3'd4, // shifting delay bits (4 cycles)
               S_COUNT   = 3'd5, // waiting for counting to finish
               S_DONE    = 3'd6; // done, waiting for ack

    reg [2:0] state, next_state;
    reg [1:0] shift_count;

    // Sequential logic: state and shift_count with synchronous reset
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

    // Next state logic combinational: pattern detection by states
    always @(*) begin
        case (state)
            S_SEARCH0: begin
                if (data == 1'b1)
                    next_state = S_SEARCH1;
                else
                    next_state = S_SEARCH0;
            end
            S_SEARCH1: begin
                if (data == 1'b1)
                    next_state = S_SEARCH2;
                else
                    next_state = S_SEARCH0;
            end
            S_SEARCH2: begin
                if (data == 1'b0)
                    next_state = S_SEARCH3;
                else
                    next_state = S_SEARCH2; // stay since next bit is '1', partial match remains
            end
            S_SEARCH3: begin
                if (data == 1'b1)
                    next_state = S_SHIFT;
                else
                    next_state = S_SEARCH0;
            end
            S_SHIFT: begin
                if (shift_count == 2'd3)
                    next_state = S_COUNT;
                else
                    next_state = S_SHIFT;
            end
            S_COUNT: begin
                if (done_counting)
                    next_state = S_DONE;
                else
                    next_state = S_COUNT;
            end
            S_DONE: begin
                if (ack)
                    next_state = S_SEARCH0;
                else
                    next_state = S_DONE;
            end
            default: next_state = S_SEARCH0;
        endcase
    end

    // Outputs combinationally driven by current state
    assign shift_ena = (state == S_SHIFT);
    assign counting  = (state == S_COUNT);
    assign done      = (state == S_DONE);

endmodule