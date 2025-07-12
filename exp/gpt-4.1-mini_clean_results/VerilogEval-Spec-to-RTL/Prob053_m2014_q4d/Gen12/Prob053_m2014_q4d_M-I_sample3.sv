module TopModule (
    input clk,
    input in,
    output reg out
);

    // Initialize output for deterministic simulation, synthesis ignores initial blocks
    initial begin
        out = 1'b0;
    end

    // D flip-flop updates output at posedge clk with XOR of in and current out
    always @(posedge clk) begin
        out <= in ^ out;
    end

endmodule