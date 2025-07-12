module TopModule (
    input  clk,
    input  areset,
    input  in,
    output reg out
);

    // State encoding
    localparam A = 1'b0;
    localparam B = 1'b1;

    reg state, next_state;

    // Next-state logic combinational block
    always @(*) begin
        case(state)
            B: next_state = (in == 1'b0) ? A : B;  // B --0--> A, B --1--> B
            A: next_state = (in == 1'b0) ? B : A;  // A --0--> B, A --1--> A
            default: next_state = B;
        endcase
    end

    // State register with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if(areset)
            state <= B;  // async reset to state B
        else
            state <= next_state;
    end

    // Moore output depends only on state
    always @(*) begin
        case(state)
            A: out = 1'b0;
            B: out = 1'b1;
            default: out = 1'b1;
        endcase
    end

endmodule