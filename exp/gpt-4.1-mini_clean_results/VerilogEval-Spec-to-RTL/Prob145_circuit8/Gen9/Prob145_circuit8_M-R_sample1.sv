module TopModule(
    input clock,
    input a,
    output p,
    output q
);

    // State encoding as 2-bit vector
    reg [1:0] state, next_state;

    // Output assignments: p = state[1], q = state[0]
    assign p = state[1];
    assign q = state[0];

    // State encoding for readability
    localparam S00 = 2'b00;
    localparam S10 = 2'b10;
    localparam S11 = 2'b11;
    localparam S01 = 2'b01;

    // Next state combinational logic
    always @(*) begin
        case(state)
            S00: next_state = a ? S10 : S00;
            S10: next_state = a ? S11 : S00;
            S11: next_state = a ? S11 : S01;
            S01: next_state = a ? S11 : S01;
            default: next_state = S00;
        endcase
    end

    // State register with synchronous reset on first posedge clock (initialize to S00)
    // We assume at simulation start, state is unknown, so initialize at first clock
    always @(posedge clock) begin
        if (^state === 1'bx) // If any bit of state is unknown, initialize
            state <= S00;
        else
            state <= next_state;
    end

endmodule