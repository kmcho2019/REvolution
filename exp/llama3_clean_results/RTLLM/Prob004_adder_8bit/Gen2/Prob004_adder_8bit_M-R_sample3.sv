module adder_8bit(
    input   [7:0] a,
    input   [7:0] b,
    input   cin,
    output  [7:0] sum,
    output  cout
);
    wire [7:0] carry; // Intermediate carry signals

    // Calculate sum and carry for each bit position
    assign sum[0] = a[0] ^ b[0] ^ cin;
    assign carry[0] = (a[0] & b[0]) | (a[0] & cin) | (b[0] & cin);

    // Use a generate loop to create instances for bits 1 to 7
    genvar i;
    generate
        for (i = 1; i < 8; i++) begin
            assign sum[i] = a[i] ^ b[i] ^ carry[i-1];
            assign carry[i] = (a[i] & b[i]) | (a[i] & carry[i-1]) | (b[i] & carry[i-1]);
        end
    endgenerate

    // Carry-out of the most significant bit is the final carry-out
    assign cout = carry[7];
endmodule