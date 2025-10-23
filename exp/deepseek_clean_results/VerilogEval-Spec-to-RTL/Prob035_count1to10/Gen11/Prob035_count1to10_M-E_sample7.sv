module TopModule (
    input clk,
    input reset,
    output [3:0] q
);

reg [9:0] one_hot;  // One-hot representation (bits 0-9 unused, bits 10:1 used)
wire [9:0] next_one_hot;

// One-hot counting logic
assign next_one_hot = reset ? 10'b0000000010 :  // Reset to position 1 (bit 1)
                    (one_hot == 10'b1000000000) ? 10'b0000000010 :  // Wrap from 10 to 1
                    {one_hot[8:0], 1'b0};  // Normal shift left

// Convert one-hot back to binary
assign q = (next_one_hot[1] ? 4'b0001 :  // 1
           next_one_hot[2] ? 4'b0010 :  // 2
           next_one_hot[3] ? 4'b0011 :  // 3
           next_one_hot[4] ? 4'b0100 :  // 4
           next_one_hot[5] ? 4'b0101 :  // 5
           next_one_hot[6] ? 4'b0110 :  // 6
           next_one_hot[7] ? 4'b0111 :  // 7
           next_one_hot[8] ? 4'b1000 :  // 8
           next_one_hot[9] ? 4'b1001 :  // 9
           4'b1010);  // 10

always @(posedge clk) begin
    one_hot <= next_one_hot;
end

endmodule