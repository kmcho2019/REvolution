module TopModule(
    input clock,
    input a,
    output p,
    output q
);

    // State encoding as 2-bit vector: {p,q}
    reg [1:0] state, next_state;

    // Flag to indicate initialization done
    reg init_done;

    // Outputs are the bits of the current state
    assign p = state[1];
    assign q = state[0];

    // State definitions
    localparam S00 = 2'b00;
    localparam S10 = 2'b10;
    localparam S11 = 2'b11;
    localparam S01 = 2'b01;

    // Synchronous process to register init_done once first clock edge passes
    always @(posedge clock) begin
        if (!init_done)
            init_done <= 1'b1;
    end

    // State register with synchronous reset on first clock edge
    always @(posedge clock) begin
        if (!init_done)
            state <= S00; // Initialize state to S00 on first clock edge
        else
            state <= next_state;
    end

    // Combinational next state logic based on current state and input a
    always @(*) begin
        case(state)
            S00: next_state = a ? S10 : S00;
            S10: next_state = a ? S11 : S00;
            S11: next_state = a ? S11 : S01;
            S01: next_state = a ? S11 : S01;
            default: next_state = S00;
        endcase
    end

endmodule