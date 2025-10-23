module adder_8bit(a, b, cin, sum, cout);
    input [7:0] a;
    input [7:0] b;
    input cin;
    output [7:0] sum;
    output cout;

    wire [7:0] carry;

    // Initialize the carry input for the least significant bit (LSB) full adder
    assign carry[0] = cin;

    // Generate the full adders for each bit position
    genvar i;
    generate
        for (i = 0; i < 8; i++) begin
            full_adder fa(
                .a(a[i]),
                .b(b[i]),
                .cin(carry[i]),
                .sum(sum[i]),
                .cout(carry[i+1])
            );
        end
    endgenerate

    // The carry-out output is the carry output from the MSB full adder
    assign cout = carry[8];

    // Define the full adder module
    module full_adder(a, b, cin, sum, cout);
        input a;
        input b;
        input cin;
        output sum;
        output cout;

        assign sum = a ^ b ^ cin;
        assign cout = (a & b) | (a & cin) | (b & cin);
    endmodule
endmodule