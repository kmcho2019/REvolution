module TopModule (
    input clk,
    input reset,
    input w,
    output z
);
    // One-hot encoded states
    localparam A = 6'b000001;
    localparam B = 6'b000010;
    localparam C = 6'b000100;
    localparam D = 6'b001000;
    localparam E = 6'b010000;
    localparam F = 6'b100000;

    reg [5:0] state, next_state;

    // Next state logic combinational
    always @(*) begin
        // default no change
        next_state = 6'b0;
        case (1'b1)
            state[A]: next_state = w ? A : B;
            state[B]: next_state = w ? D : C;
            state[C]: next_state = w ? D : E;
            state[D]: next_state = w ? A : F;
            state[E]: next_state = w ? D : E;
            state[F]: next_state = w ? D : C;
            default: next_state = A; // reset fallback
        endcase
    end

    // Sequential state update
    always @(posedge clk) begin
        if (reset)
            state <= A;
        else
            state <= next_state;
    end

    // Output z = 1 if in E or F
    assign z = state[E] | state[F];

endmodule