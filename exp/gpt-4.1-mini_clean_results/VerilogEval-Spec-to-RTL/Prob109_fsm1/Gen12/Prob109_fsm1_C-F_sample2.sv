module TopModule (
    input  clk,
    input  areset,
    input  in,
    output reg out
);

    reg state; // 0 = A, 1 = B

    // State register with asynchronous reset and minimal next-state logic
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= 1'b1; // reset to B
        else
            state <= state ^ ~in; // minimal XOR-based next-state logic
    end

    // Moore machine output: depends only on current state
    always @(*) begin
        out = state;
    end

endmodule