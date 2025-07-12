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

    // Next state logic (combinational)
    always @(*) begin
        case (state)
            B: next_state = in ? B : A; // from B: '1' stay B, '0' to A
            A: next_state = in ? A : B; // from A: '1' stay A, '0' to B
            default: next_state = B;    // default safe state
        endcase
    end

    // State register with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= B;
        else
            state <= next_state;
    end

    // Moore output depends on current state
    always @(*) begin
        out = state; // output = state encoding
    end

endmodule