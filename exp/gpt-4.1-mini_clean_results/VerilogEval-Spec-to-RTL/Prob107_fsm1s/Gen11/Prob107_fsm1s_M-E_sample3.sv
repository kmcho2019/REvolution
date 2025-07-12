module TopModule(
    input  clk,
    input  reset,
    input  in,
    output out
);

    // One-hot state encoding
    localparam [1:0] B = 2'b01;
    localparam [1:0] A = 2'b10;

    reg [1:0] state, next_state;

    // State register with synchronous active-high reset
    always @(posedge clk) begin
        if (reset)
            state <= B;
        else
            state <= next_state;
    end

    // Next state logic as combinational logic without case
    always @(*) begin
        // Default: hold current state
        next_state = 2'b00;
        if (state == B)
            next_state = (in == 1'b0) ? A : B;
        else // state == A
            next_state = (in == 1'b0) ? B : A;
    end

    // Moore output: out=1 when in state B (state[0] is 1)
    assign out = state[0];

endmodule