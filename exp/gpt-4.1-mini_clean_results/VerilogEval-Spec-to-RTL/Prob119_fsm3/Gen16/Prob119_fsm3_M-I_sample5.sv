module TopModule(
    input  clk,
    input  areset,
    input  in,
    output reg out
);

    // One-hot state encoding: 4 states = 4 flip-flops
    localparam A = 4'b0001,
               B = 4'b0010,
               C = 4'b0100,
               D = 4'b1000;

    reg [3:0] state, next_state;

    // Sequential logic with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= A;
        else
            state <= next_state;
    end

    // Combinational next state logic with non-blocking assignments
    always @(*) begin
        // Default next state to current state
        next_state = 4'b0000;

        case (1'b1)
            state[A]: next_state = in ? B : A;
            state[B]: next_state = in ? B : C;
            state[C]: next_state = in ? D : A;
            state[D]: next_state = in ? B : C;
            default:  next_state = A; // safety net
        endcase
    end

    // Output logic: Moore machine - output depends only on current state
    always @(posedge clk or posedge areset) begin
        if (areset)
            out <= 1'b0;
        else
            out <= state[D];
    end

endmodule