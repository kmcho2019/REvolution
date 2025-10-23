module TopModule (
    input  clk,
    input  areset,
    input  in,
    output reg out
);

    // Asynchronous reset to B (out=1), and state transition encoded in output itself
    always @(posedge clk or posedge areset) begin
        if (areset)
            out <= 1'b1; // reset to B
        else
            out <= out ^ (~in);
    end

endmodule