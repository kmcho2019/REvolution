module TopModule (
    input  clk,
    input  in,
    output reg out
);

    // Note: No reset and no initial block to ensure synthesis compatibility.
    // The initial state of 'out' is undefined at startup as per the specification.

    always @(posedge clk) begin
        out <= in ^ out;
    end

endmodule