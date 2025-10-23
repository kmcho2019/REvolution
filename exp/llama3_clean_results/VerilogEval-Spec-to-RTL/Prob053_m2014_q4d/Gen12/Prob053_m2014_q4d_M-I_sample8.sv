module TopModule(
    input clk,
    input in,
    output reg out
);

// Combinational logic: XOR gate
reg xor_out;

// Sequential logic: D flip-flop
always @(posedge clk) begin
    out <= in ^ out;
end

// No explicit initialization to rely on tool defaults or initialization sequences in the testbench

endmodule