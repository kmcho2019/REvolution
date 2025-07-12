module TopModule (
    input  wire a,     // First input bit
    input  wire b,     // Second input bit
    output wire sum,   // Sum output (a XOR b)
    output wire cout   // Carry output (a AND b)
);

// Function to perform half adder operation returning {cout, sum}
function [1:0] half_adder;
    input x;
    input y;
    begin
        half_adder[0] = x ^ y;  // sum
        half_adder[1] = x & y;  // carry
    end
endfunction

wire [1:0] result;

assign result = half_adder(a, b);
assign sum = result[0];
assign cout = result[1];

endmodule