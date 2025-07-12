module TopModule(
    input  clk,
    input  areset,
    input  j,
    input  k,
    output reg out
);

    always @(posedge clk or posedge areset) begin
        if (areset)
            out <= 1'b0;           // OFF
        else
            out <= out ? ~k : j;  // ON: next state = ~k, OFF: next state = j
    end

endmodule