module adder_8bit (
    input  wire [7:0] a,
    input  wire [7:0] b,
    input  wire       cin,
    output reg  [7:0] sum,
    output reg        cout
);

    // Function to perform 1-bit full addition
    function automatic [1:0] full_adder_func;
        input bit x;
        input bit y;
        input bit cin;
        reg   s;
        reg   c;
        begin
            s = x ^ y ^ cin;
            c = (x & y) | (x & cin) | (y & cin);
            full_adder_func = {c, s}; // {cout, sum}
        end
    endfunction

    integer i;
    reg carry;
    always @(*) begin
        carry = cin;
        for (i = 0; i < 8; i = i + 1) begin
            {carry, sum[i]} = full_adder_func(a[i], b[i], carry);
        end
        cout = carry;
    end

endmodule