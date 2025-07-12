module TopModule (
    input  clk,
    input  areset,
    input  in,
    output reg out
);

    reg state;

    // State register with async reset and direct next-state logic
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= 1'b1;          // state B
        else
            state <= (state) ? (in ? 1'b1 : 1'b0) : (in ? 1'b0 : 1'b1);
            // if state=1 (B): next = in? B(1):A(0)
            // if state=0 (A): next = in? A(0):B(1)
    end

    // Output is the state value directly: B=1, A=0
    always @(*) begin
        out = state;
    end

endmodule