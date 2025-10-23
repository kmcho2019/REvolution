module TopModule(
    input clk,
    input in,
    output reg out
);

// Continuous assignment for the combinational logic
wire xor_result = in ^ out;

// Always block for the sequential logic
always @(posedge clk) begin
    out <= xor_result; // Update out with the result of XOR operation at the next clock edge
end

endmodule