module TopModule (
    input  clk,
    input  areset,
    input  in,
    output out
);

    // State encoding: A=0, B=1
    localparam A = 1'b0;
    localparam B = 1'b1;

    reg state;

    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= B;              // Asynchronous reset to B
        else
            state <= state ^ ~in;    // Next state logic integrated (XOR)
    end

    // Moore output directly from registered state
    assign out = state;

endmodule