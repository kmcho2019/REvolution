module TopModule (
    input  clk,
    input  reset,
    input  in,
    output out
);

    // One-hot state encoding using localparams for clarity
    localparam [3:0] A = 4'b0001;
    localparam [3:0] B = 4'b0010;
    localparam [3:0] C = 4'b0100;
    localparam [3:0] D = 4'b1000;

    reg [3:0] state, next_state;

    // Next state logic: simplified by one-hot encoding
    always @(*) begin
        // Default next_state to 4'b0000 to avoid inferred latches if any
        next_state = 4'b0000;
        case (state)
            A: next_state = (in == 1'b0) ? A : B;
            B: next_state = (in == 1'b0) ? C : B;
            C: next_state = (in == 1'b0) ? A : D;
            D: next_state = (in == 1'b0) ? C : B;
            default: next_state = A; // safe fallback
        endcase
    end

    // Sequential state register with synchronous active-high reset
    always @(posedge clk) begin
        if (reset)
            state <= A;
        else
            state <= next_state;
    end

    // Output is high only in state D
    assign out = state[3]; // D corresponds to bit 3

endmodule