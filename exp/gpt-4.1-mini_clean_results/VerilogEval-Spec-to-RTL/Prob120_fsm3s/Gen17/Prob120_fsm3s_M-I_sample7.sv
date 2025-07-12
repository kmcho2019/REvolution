module TopModule (
    input  clk,
    input  reset,
    input  in,
    output out
);

    // One-hot state encoding
    localparam
        A = 4'b0001,
        B = 4'b0010,
        C = 4'b0100,
        D = 4'b1000;

    reg [3:0] state, next_state;

    // Next-state combinational logic for each bit
    always @(*) begin
        // Default next_state to zero (should be overwritten)
        next_state = 4'b0000;
        case (1'b1) // one-hot decoding of current state
            state[0]: next_state = (in == 1'b0) ? A : B; // A
            state[1]: next_state = (in == 1'b0) ? C : B; // B
            state[2]: next_state = (in == 1'b0) ? A : D; // C
            state[3]: next_state = (in == 1'b0) ? C : B; // D
            default:  next_state = A; // safe default
        endcase
    end

    // Sequential state register with synchronous active-high reset
    always @(posedge clk) begin
        if (reset)
            state <= A;
        else
            state <= next_state;
    end

    // Moore output: output is 1 only in state D (bit 3)
    assign out = state[3];

endmodule