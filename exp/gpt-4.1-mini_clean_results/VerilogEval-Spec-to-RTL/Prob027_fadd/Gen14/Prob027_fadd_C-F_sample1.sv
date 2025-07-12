module TopModule (
    input  a,
    input  b,
    input  cin,
    output cout,
    output sum
);
    // Define half adder logic as a local function returning {sum, cout}
    function [1:0] half_adder;
        input x;
        input y;
        begin
            half_adder[0] = x ^ y;   // sum
            half_adder[1] = x & y;   // cout
        end
    endfunction

    wire sum1, cout1, cout2;

    // First half adder: adds a and b
    assign {cout1, sum1} = half_adder(a, b);
    // Second half adder: adds sum1 and cin
    assign {cout2, sum} = half_adder(sum1, cin);
    // Carry out is OR of carry outputs from both half adders
    assign cout = cout1 | cout2;

endmodule