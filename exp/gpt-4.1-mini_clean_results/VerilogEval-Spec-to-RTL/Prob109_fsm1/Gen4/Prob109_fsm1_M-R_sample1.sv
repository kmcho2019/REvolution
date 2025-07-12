module TopModule (
    input  clk,
    input  areset,
    input  in,
    output reg out
);

    localparam A = 1'b0, B = 1'b1;

    reg state, next_state;

    // Next-state logic combinational block
    always @(*) begin
        case(state)
            B: next_state = in ? B : A;
            A: next_state = in ? A : B;
            default: next_state = B;
        endcase
    end

    // State register with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= B;
        else
            state <= next_state;
    end

    // Output logic combinational block (Moore output depends only on state)
    always @(*) begin
        case(state)
            A: out = 1'b0;
            B: out = 1'b1;
            default: out = 1'b1;
        endcase
    end

endmodule