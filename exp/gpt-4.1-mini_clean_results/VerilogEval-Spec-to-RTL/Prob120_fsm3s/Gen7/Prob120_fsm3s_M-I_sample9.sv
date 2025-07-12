module TopModule (
    input  clk,
    input  reset,
    input  in,
    output reg out
);

    // One-hot state encoding using localparams
    localparam A = 4'b0001;
    localparam B = 4'b0010;
    localparam C = 4'b0100;
    localparam D = 4'b1000;

    reg [3:0] state, next_state;

    // Combinational next state logic with one-hot encoding
    always @(*) begin
        // Default: no state
        next_state = 4'b0000;
        case (1'b1)  // one-hot state decode
            state[0]: // A
                next_state = (in == 1'b0) ? A : B;
            state[1]: // B
                next_state = (in == 1'b0) ? C : B;
            state[2]: // C
                next_state = (in == 1'b0) ? A : D;
            state[3]: // D
                next_state = (in == 1'b0) ? C : B;
            default:
                next_state = A;  // Safe fallback to A
        endcase
    end

    // Sequential logic: state register with synchronous active-high reset
    always @(posedge clk) begin
        if (reset)
            state <= A;
        else
            state <= next_state;
    end

    // Moore output logic: output = 1 only in state D
    always @(*) begin
        out = state[3];
    end

endmodule