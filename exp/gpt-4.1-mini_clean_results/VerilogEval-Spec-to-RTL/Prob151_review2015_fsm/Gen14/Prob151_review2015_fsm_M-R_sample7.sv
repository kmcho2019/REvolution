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

    // One-hot state encoding
    localparam [8:0]
        SEARCH0 = 9'b000000001,
        SEARCH1 = 9'b000000010,
        SEARCH2 = 9'b000000100,
        SEARCH3 = 9'b000001000,
        SHIFT0  = 9'b000010000,
        SHIFT1  = 9'b000100000,
        SHIFT2  = 9'b001000000,
        SHIFT3  = 9'b010000000,
        COUNT   = 9'b100000000,
        DONE    = 9'b000000000; // DONE state assigned zero here to handle separately

    // Because we have 9 states, but want 9 bits, assign DONE as separate bit
    // We'll add a bit for DONE as 9'b1000000000 (10 bits total)
    // For clarity, declare 10-bit one-hot for states:
    localparam [9:0]
        S_SEARCH0 = 10'b0000000001,
        S_SEARCH1 = 10'b0000000010,
        S_SEARCH2 = 10'b0000000100,
        S_SEARCH3 = 10'b0000001000,
        S_SHIFT0  = 10'b0000010000,
        S_SHIFT1  = 10'b0000100000,
        S_SHIFT2  = 10'b0001000000,
        S_SHIFT3  = 10'b0010000000,
        S_COUNT   = 10'b0100000000,
        S_DONE    = 10'b1000000000;

    reg [9:0] state, next_state;

    // State register
    always @(posedge clk) begin
        if (reset)
            state <= S_SEARCH0;
        else
            state <= next_state;
    end

    // Next state combinational logic (one-hot FSM style)
    always @(*) begin
        next_state = 10'd0; // default no state active

        if (state == S_SEARCH0) next_state = data ? S_SEARCH1 : S_SEARCH0;
        else if (state == S_SEARCH1) next_state = data ? S_SEARCH2 : S_SEARCH0;
        else if (state == S_SEARCH2) next_state = (~data) ? S_SEARCH3 : S_SEARCH2;
        else if (state == S_SEARCH3) next_state = data ? S_SHIFT0 : S_SEARCH0;

        else if (state == S_SHIFT0) next_state = S_SHIFT1;
        else if (state == S_SHIFT1) next_state = S_SHIFT2;
        else if (state == S_SHIFT2) next_state = S_SHIFT3;
        else if (state == S_SHIFT3) next_state = S_COUNT;

        else if (state == S_COUNT) next_state = done_counting ? S_DONE : S_COUNT;
        else if (state == S_DONE) next_state = ack ? S_SEARCH0 : S_DONE;
        else next_state = S_SEARCH0; // default fallback
    end

    // Outputs: Moore type, based on state bits
    assign shift_ena = |(state & (S_SHIFT0 | S_SHIFT1 | S_SHIFT2 | S_SHIFT3));
    assign counting  = (state == S_COUNT);
    assign done      = (state == S_DONE);

endmodule