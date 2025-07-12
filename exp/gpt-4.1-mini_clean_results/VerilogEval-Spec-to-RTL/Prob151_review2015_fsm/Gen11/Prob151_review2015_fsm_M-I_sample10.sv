module TopModule (
    input        clk,
    input        reset,
    input        data,
    input        done_counting,
    input        ack,
    output       shift_ena,
    output       counting,
    output       done
);

    // One-hot state encoding: 7 states, use 7 bits (bit 0 corresponds to SEARCH0, etc.)
    localparam [6:0]
        SEARCH0 = 7'b0000001,
        SEARCH1 = 7'b0000010,
        SEARCH2 = 7'b0000100,
        SEARCH3 = 7'b0001000,
        SHIFT   = 7'b0010000,
        COUNT   = 7'b0100000,
        DONE    = 7'b1000000;

    reg [6:0] state, next_state;
    reg [1:0] shift_count;

    // State register with synchronous reset
    always @(posedge clk) begin
        if (reset) begin
            state <= SEARCH0;
            shift_count <= 2'b00;
        end else begin
            state <= next_state;
            if (state[4])  // SHIFT state bit
                shift_count <= shift_count + 1'b1;
            else
                shift_count <= 2'b00;
        end
    end

    // Next state logic (combinational)
    always @(*) begin
        // Default next state is hold current state
        next_state = state;

        if (state == SEARCH0) begin
            next_state = data ? SEARCH1 : SEARCH0;
        end else if (state == SEARCH1) begin
            next_state = data ? SEARCH2 : SEARCH0;
        end else if (state == SEARCH2) begin
            next_state = (~data) ? SEARCH3 : SEARCH2; // allow overlapping pattern detection
        end else if (state == SEARCH3) begin
            next_state = data ? SHIFT : SEARCH0;
        end else if (state == SHIFT) begin
            if (shift_count == 2'd3)
                next_state = COUNT;
            else
                next_state = SHIFT;
        end else if (state == COUNT) begin
            next_state = done_counting ? DONE : COUNT;
        end else if (state == DONE) begin
            next_state = ack ? SEARCH0 : DONE;
        end else begin
            next_state = SEARCH0;
        end
    end

    // Outputs driven by state bits
    assign shift_ena = (state == SHIFT);
    assign counting  = (state == COUNT);
    assign done      = (state == DONE);

endmodule