module TopModule(
    input clk,
    input in,
    output reg out
);

// Directly use the XOR output to toggle the T flip-flop
always @(posedge clk) begin
    if (in ^ out) begin
        out <= ~out; // Toggle out when in and out are different
    end
end

endmodule