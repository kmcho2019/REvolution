module TopModule(
    input  wire clk,
    input  wire areset,
    input  wire in,
    output reg  out
);

    // One-hot state encoding
    localparam [3:0]
        A = 4'b0001,
        B = 4'b0010,
        C = 4'b0100,
        D = 4'b1000;

    reg [3:0] state, next_state;

    // Next state logic combinational
    always @(*) begin
        // Default no state
        next_state = 4'b0000;
        case (state)
            A: next_state = (in == 1'b0) ? A : B;
            B: next_state = (in == 1'b0) ? C : B;
            C: next_state = (in == 1'b0) ? A : D;
            D: next_state = (in == 1'b0) ? C : B;
            default: next_state = A; // Should never happen
        endcase
    end

    // State register with async active-high reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= A;
        else
            state <= next_state;
    end

    // Moore output: 1 when in D state, else 0
    always @(*) begin
        out = state[D];
    end

endmodule