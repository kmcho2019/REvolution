module TopModule (
    input  clk,
    input  areset,
    input  in,
    output reg out
);

    wire inv_in = ~in;

    always @(posedge clk or posedge areset) begin
        if (areset)
            out <= 1'b1; // reset to B
        else
            out <= out ^ inv_in;
    end

endmodule