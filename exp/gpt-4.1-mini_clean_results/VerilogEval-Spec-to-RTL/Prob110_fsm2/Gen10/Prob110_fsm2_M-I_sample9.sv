module TopModule(
    input  clk,
    input  areset,
    input  j,
    input  k,
    output reg out
);

    reg next_out;

    // Next state logic combinational (simplified boolean expression)
    always @(*) begin
        next_out = (out & ~k) | (~out & j);
    end

    // State register with asynchronous active-high reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            out <= 1'b0;       // OFF state on reset
        else
            out <= next_out;
    end

endmodule