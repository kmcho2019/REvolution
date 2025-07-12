module TopModule(
    input clk,
    input in,
    output reg out = 1'b0
);

    // D flip-flop with XOR operation
    always @(posedge clk) begin
        out <= in ^ out;
    end

endmodule