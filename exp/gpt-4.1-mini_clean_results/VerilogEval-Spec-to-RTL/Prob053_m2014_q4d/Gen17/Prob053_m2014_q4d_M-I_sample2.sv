module TopModule (
    input  wire clk,
    input  wire in,
    output reg  out
);

    // Sequential logic: D flip-flop with no reset,
    // input is XOR of 'in' and current 'out'.
    always @(posedge clk) begin
        out <= in ^ out;
    end

endmodule