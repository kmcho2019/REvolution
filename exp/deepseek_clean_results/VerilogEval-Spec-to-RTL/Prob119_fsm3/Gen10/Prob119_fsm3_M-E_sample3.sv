module TopModule (
    input clk,
    input areset,
    input in,
    output out
);

    // One-hot state encoding
    parameter [3:0] A = 4'b0001;
    parameter [3:0] B = 4'b0010;
    parameter [3:0] C = 4'b0100;
    parameter [3:0] D = 4'b1000;

    reg [3:0] state, next_state;

    // Combinational next state logic
    always @(*) begin
        next_state = 4'b0;
        case (1'b1) // synthesis parallel_case
            state[A]: next_state = in ? B : A;
            state[B]: next_state = in ? B : C;
            state[C]: next_state = in ? D : A;
            state[D]: next_state = in ? B : C;
            default:   next_state = A;
        endcase
    end

    // State register with async reset
    always @(posedge clk or posedge areset) begin
        if (areset) state <= A;
        else state <= next_state;
    end

    // Output is simply the D state bit
    assign out = state[D];

endmodule