// Define a full adder module
module full_adder(a, b, cin, sum, cout);
    input a, b, cin;
    output sum, cout;

    assign sum = a ^ b ^ cin;
    assign cout = (a & b) | (a & cin) | (b & cin);
endmodule

// Define the 8-bit adder module
module adder_8bit(a, b, cin, sum, cout);
    input [7:0] a;
    input [7:0] b;
    input cin;
    output [7:0] sum;
    output cout;

    wire [6:0] carry;

    // First full adder (bit 0)
    full_adder fa0(a[0], b[0], cin, sum[0], carry[0]);

    // Remaining full adders (bits 1-7)
    generate
        for (genvar i = 1; i < 8; i++) begin
            full_adder fa(a[i], b[i], carry[i-1], sum[i], carry[i]);
        end
    endgenerate

    // Assign the final carry-out
    assign cout = carry[7];
endmodule