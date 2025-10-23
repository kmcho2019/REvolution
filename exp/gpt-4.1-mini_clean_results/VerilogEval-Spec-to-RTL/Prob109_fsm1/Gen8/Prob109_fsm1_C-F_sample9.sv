module TopModule (
    input  clk,
    input  areset,
    input  in,
    output out
);

    // State encoding
    localparam A = 1'b0;
    localparam B = 1'b1;

    reg state;
    reg next_state;

    // Next state combinational logic using simple XOR
    always @(*) begin
        next_state = state ^ ~in;
    end

    // Sequential state update with asynchronous reset to B
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= B;
        else
            state <= next_state;
    end

    // Output driven directly from registered state (Moore output)
    assign out = state;

endmodule