module TopModule (
    input clk,
    input reset,
    input data,
    input done_counting,
    input ack,
    output shift_ena,
    output counting,
    output done
);

    // One-hot state encoding
    localparam IDLE      = 4'b0001;
    localparam SHIFT     = 4'b0010;
    localparam COUNTING  = 4'b0100;
    localparam DONE      = 4'b1000;

    reg [3:0] state, next_state;
    reg [1:0] shift_cnt;
    reg [3:0] pattern;

    // Combinational next-state logic
    always @(*) begin
        next_state = state;
        case (1'b1) // synthesis parallel_case
            state[0]: // IDLE
                if (pattern == 4'b1101)
                    next_state = SHIFT;

            state[1]: // SHIFT
                if (shift_cnt == 2'b11)
                    next_state = COUNTING;

            state[2]: // COUNTING
                if (done_counting)
                    next_state = DONE;

            state[3]: // DONE
                if (ack)
                    next_state = IDLE;
        endcase
    end

    // Sequential logic
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            shift_cnt <= 2'b0;
            pattern <= 4'b0;
        end else begin
            state <= next_state;

            // Pattern register update
            if (state[0]) // IDLE
                pattern <= {pattern[2:0], data};
            else if (state[3] && ack) // DONE with ack
                pattern <= 4'b0;

            // Shift counter update
            if (state[1]) begin // SHIFT
                shift_cnt <= shift_cnt + 1;
                if (next_state != SHIFT)
                    shift_cnt <= 2'b0;
            end
        end
    end

    // Output assignments
    assign shift_ena = state[1]; // SHIFT
    assign counting  = state[2]; // COUNTING
    assign done      = state[3]; // DONE

endmodule