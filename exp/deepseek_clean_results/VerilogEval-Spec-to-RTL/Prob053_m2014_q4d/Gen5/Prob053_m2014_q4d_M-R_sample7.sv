module TopModule (
    input clk,
    input in,
    output reg out
);

    always @(posedge clk) begin
        // Combinational XOR (blocking assignment)
        out = in ^ out;
        // Flip-flop update (non-blocking would also work here)
        out <= out;
    end

endmodule