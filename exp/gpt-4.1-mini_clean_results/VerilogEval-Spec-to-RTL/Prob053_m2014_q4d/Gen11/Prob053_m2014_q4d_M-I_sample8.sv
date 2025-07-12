module TopModule (
    input clk,
    input in,
    output reg out
);

    // D flip-flop updates output at posedge clk with XOR of in and current out
    always @(posedge clk) begin
        out <= in ^ out;
    end

endmodule