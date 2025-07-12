module TopModule(
    input  clk,
    input  areset,
    input  in,
    output reg out
);

    // One-hot state encoding
    parameter A = 4'b0001,
              B = 4'b0010,
              C = 4'b0100,
              D = 4'b1000;

    reg [3:0] state, next_state;

    // State register with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= A;
        else
            state <= next_state;
    end

    // Next state logic with one-hot encoding
    always @(*) begin
        next_state = 4'b0000;
        case (1'b1) // priority encoding of current state bit
            state[0]: next_state = in ? B : A; // A
            state[1]: next_state = in ? B : C; // B
            state[2]: next_state = in ? D : A; // C
            state[3]: next_state = in ? B : C; // D
            default:  next_state = A;           // Default to A on invalid state
        endcase
    end

    // Output logic: out=1 only in state D (one-hot bit 3)
    always @(*) begin
        out = (state == D) ? 1'b1 : 1'b0;
    end

endmodule