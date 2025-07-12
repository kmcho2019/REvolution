module TopModule (
    input clk,
    input in,
    output reg out
);

    always @(posedge clk) begin
        out <= in ^ out;  // Direct XOR feedback in the flip-flop
    end

endmodule