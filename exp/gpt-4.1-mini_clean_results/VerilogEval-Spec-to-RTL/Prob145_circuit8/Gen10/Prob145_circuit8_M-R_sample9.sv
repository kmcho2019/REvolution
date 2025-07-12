module TopModule(
    input clock,
    input a,
    output p,
    output q
);

    // Declare state registers and next state logic
    reg [1:0] state, next_state;

    // Define outputs as bits of state
    assign p = state[1];
    assign q = state[0];

    // Define state encodings for clarity
    localparam S00 = 2'b00,
               S10 = 2'b10,
               S11 = 2'b11,
               S01 = 2'b01;

    // Internal synchronous reset generation (reset for one cycle at first clock)
    reg reset_n;
    initial reset_n = 0;
    always @(posedge clock) begin
        if (!reset_n)
            reset_n <= 1'b1; // Deassert reset after first clock posedge
    end

    // State register with synchronous reset
    always @(posedge clock) begin
        if (!reset_n)
            state <= S00;  // Initialize to S00 at first clock
        else
            state <= next_state;
    end

    // Next state combinational logic based on current state and input a
    always @(*) begin
        case (state)
            S00: next_state = a ? S10 : S00;
            S10: next_state = a ? S11 : S00;
            S11: next_state = a ? S11 : S01;
            S01: next_state = a ? S11 : S01;
            default: next_state = S00;
        endcase
    end

endmodule