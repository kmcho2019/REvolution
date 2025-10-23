module TopModule(
    input clk,
    input in,
    output reg out = 1'b0 // Initialize out to 0
);

// Sequential logic for D flip-flop, update out on the rising edge of clk
always @(posedge clk) begin
    // Update out with the result of XOR operation between in and out
    out <= in ^ out;
end

endmodule