module adder_8bit(
    input   [7:0] a,
    input   [7:0] b,
    input       cin,
    output  [7:0] sum,
    output      cout
);

wire [8:0] c;  // Carry signal, including cin as c[0]

// Initialize carry-in
assign c[0] = cin;

// Calculate carry and sum signals in a loop
genvar i;
generate
    for (i = 0; i < 8; i++) begin
        // Calculate carry signal directly
        assign c[i+1] = (a[i] & b[i]) | (a[i] & c[i]) | (b[i] & c[i]);
        
        // Calculate sum using XOR operation
        assign sum[i] = a[i] ^ b[i] ^ c[i];
    end
endgenerate

// Calculate carry-out
assign cout = c[8];

endmodule