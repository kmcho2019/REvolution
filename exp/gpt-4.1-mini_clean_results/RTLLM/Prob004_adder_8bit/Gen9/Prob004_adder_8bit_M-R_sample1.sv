module adder_8bit (
    input  wire [7:0] a,    // Operand A
    input  wire [7:0] b,    // Operand B
    input  wire       cin,  // Carry-in
    output wire [7:0] sum,  // Sum output
    output wire       cout  // Carry-out
);

    // Internal carry wires
    wire [7:0] carry;

    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : bit_adder
            if (i == 0) begin
                // First bit: carry-in is cin
                assign sum[i] = a[i] ^ b[i] ^ cin;
                assign carry[i] = (a[i] & b[i]) | (a[i] & cin) | (b[i] & cin);
            end else begin
                assign sum[i] = a[i] ^ b[i] ^ carry[i-1];
                assign carry[i] = (a[i] & b[i]) | (a[i] & carry[i-1]) | (b[i] & carry[i-1]);
            end
        end
    endgenerate

    assign cout = carry[7];

endmodule