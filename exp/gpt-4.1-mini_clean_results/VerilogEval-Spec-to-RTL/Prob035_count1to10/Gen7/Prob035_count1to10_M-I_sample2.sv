module TopModule(
    input clk,
    input reset,
    output reg [3:0] q
);

// Detect if q == 10 (binary 1010) using minimal bitwise condition
wire is_ten = q[3] & ~q[2] & q[1] & ~q[0];

// Next count logic without using full adder: increment with carry ripple
// Counting 1..10 (decimal), after 10 wrap to 1
wire [3:0] next_q = is_ten ? 4'd1 : 
    { // bit3
      q[3] ^ (q[2] & q[1] & q[0]),
      // bit2
      ~q[2] & q[1] & q[0] | (q[2] & ~q[1]) | (q[2] & ~q[0]),
      // bit1
      ~q[1] & q[0] | (q[1] & ~q[0]),
      // bit0
      ~q[0]
    };

// This logic is constructed by manually writing increment logic bits:
// bit0 toggles every count (inversion),
// bit1 toggles when bit0 is 1 (q[0] == 1),
// bit2 toggles when bits 1 and 0 are 1 (i.e., when incrementing from 3 to 4),
// bit3 toggles when bits 2,1,0 are 1 (counting from 7 to 8).
// The logic above uses sum-of-products form equivalent to q+1 increment for count < 10.

always @(posedge clk) begin
    if (reset)
        q <= 4'd1;
    else
        q <= next_q;
end

endmodule