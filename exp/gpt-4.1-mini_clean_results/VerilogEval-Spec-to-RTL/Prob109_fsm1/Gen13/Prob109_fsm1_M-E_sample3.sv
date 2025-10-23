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
        case(state)
            B: next_state = in ? B : A;
            A: next_state = in ? A : B;
            default: next_state = B; // safe default
        endcase
    end

    // State register and asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= B;
        else
            state <= next_state;
    end

    // Moore output: depends only on state, registered output
    always @(posedge clk or posedge areset) begin
        if (areset)
            out <= 1'b1; // output of state B
        else
            out <= state;
    end

endmodule