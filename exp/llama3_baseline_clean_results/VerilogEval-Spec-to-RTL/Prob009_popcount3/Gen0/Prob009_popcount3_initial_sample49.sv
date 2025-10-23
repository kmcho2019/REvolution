module TopModule(
    input  [2:0] in,  // 3-bit input vector
    output [1:0] out  // 2-bit output vector
);

// Population count: count the number of '1's in the input vector
wire [1:0] count;

// Count the number of '1's in the input vector
assign count[0] = in[0] ^ in[1] ^ in[2];  // Use XOR to count odd number of '1's
assign count[1] = (in[0] & in[1]) | (in[0] & in[2]) | (in[1] & in[2]);  // Use AND and OR to count even number of '1's greater than 1

// Encode the count into a 2-bit binary number
always @(in) begin
    case ({in[0], in[1], in[2]})
        3'b000: out = 2'b00;  // 0 '1's
        3'b001, 3'b010, 3'b100: out = 2'b01;  // 1 '1'
        3'b011, 3'b101, 3'b110: out = 2'b10;  // 2 '1's
        3'b111: out = 2'b11;  // 3 '1's
    endcase
end

endmodule