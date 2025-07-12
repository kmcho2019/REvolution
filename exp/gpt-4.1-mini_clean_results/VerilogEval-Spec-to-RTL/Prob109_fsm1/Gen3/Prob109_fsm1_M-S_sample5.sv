module TopModule(
    input clk,
    input areset,
    input in,
    output reg out
);

    localparam A = 1'b0;
    localparam B = 1'b1;

    reg state, next_state;

    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= B;
        else
            state <= next_state;
    end

    always @(*) begin
        case(state)
            B: next_state = (in == 1'b0) ? A : B;
            A: next_state = (in == 1'b0) ? B : A;
            default: next_state = B;
        endcase
        out = state; // output is 1 in B, 0 in A
    end

endmodule