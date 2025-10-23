module TopModule (
    input  clk,
    input  areset,
    input  in,
    output out
);

    // State encoding
    localparam A = 1'b0;
    localparam B = 1'b1;

    reg state, next_state;

    // Next state combinational logic using XOR expression
    always @(*) begin
        next_state = state ^ (~in);
    end

    // Sequential state update with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= B;
        else
            state <= next_state;
    end

    // Moore output directly from registered state
    assign out = state;

endmodule