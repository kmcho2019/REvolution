module TopModule (
    input a,
    input b,
    output sum,
    output cout
);

    function automatic [1:0] half_adder;
        input a;
        input b;
        begin
            half_adder[0] = a ^ b;  // sum
            half_adder[1] = a & b;   // cout
        end
    endfunction

    wire [1:0] result;
    assign result = half_adder(a, b);
    assign sum = result[0];
    assign cout = result[1];

endmodule