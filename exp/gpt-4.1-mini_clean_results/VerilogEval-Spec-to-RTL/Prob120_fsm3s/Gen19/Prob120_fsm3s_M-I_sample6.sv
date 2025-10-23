module TopModule (
    input  clk,
    input  reset,
    input  in,
    output reg out
);

    // One-hot encoding: A=0001, B=0010, C=0100, D=1000
    localparam A = 4'b0001, B = 4'b0010, C = 4'b0100, D = 4'b1000;
    reg [3:0] state, next_state;

    always @(posedge clk) begin
        if (reset)
            state <= A;
        else
            state <= next_state;
    end

    always @(*) begin
        // Default no change
        next_state = 4'b0000;
        case (1'b1)
            state[A]: next_state = in ? B : A;
            state[B]: next_state = in ? B : C;
            state[C]: next_state = in ? D : A;
            state[D]: next_state = in ? B : C;
            default:  next_state = A;
        endcase
    end

    always @(*) begin
        // Output is 1 only in state D
        out = state[D];
    end

endmodule