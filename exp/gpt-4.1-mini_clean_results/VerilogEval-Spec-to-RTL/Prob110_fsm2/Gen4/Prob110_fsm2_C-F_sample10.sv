module TopModule(
    input  clk,
    input  areset,
    input  j,
    input  k,
    output reg out
);

    reg next_out;

    // Next state logic combinational
    always @(*) begin
        if (out == 1'b0)       // OFF state
            next_out = j ? 1'b1 : 1'b0;
        else                   // ON state
            next_out = k ? 1'b0 : 1'b1;
    end

    // State register with asynchronous active-high reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            out <= 1'b0;       // OFF state on reset
        else
            out <= next_out;
    end

endmodule