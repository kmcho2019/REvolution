module TopModule (
    input clk,
    input in,
    output reg out
);

    always @(posedge clk) begin
        out <= in ^ out;  // XOR of input and current output
    end

endmodule