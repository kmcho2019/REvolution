module TopModule(
    input clk,
    input in,
    output reg out
);

reg xor_result; // Temporary signal to hold the XOR result

// Combinational logic to compute the XOR result
always @(*) begin
    xor_result = in ^ out;
end

// Sequential logic to update 'out' based on the XOR result
always @(posedge clk) begin
    out <= xor_result;
end

endmodule