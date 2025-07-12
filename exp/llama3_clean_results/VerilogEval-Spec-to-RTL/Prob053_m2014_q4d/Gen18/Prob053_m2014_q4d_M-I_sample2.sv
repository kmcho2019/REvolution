module TopModule(
    input clk,
    input in,
    output reg out = 1'b0 // Initialize out to 0
);

reg temp; // Temporary signal to hold the result of XOR operation

always @(*) // Combinational logic block
    temp = in ^ out;

always @(posedge clk) // Sequential logic block
    out <= temp;

endmodule