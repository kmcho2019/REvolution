module adder_8bit(
    input   [7:0] a,
    input   [7:0] b,
    input       cin,
    output  [7:0] sum,
    output      cout
);

// Internal signals for carry lookahead
wire [7:0] g;  // Generate signal
wire [7:0] p;  // Propagate signal
wire [8:0] c;  // Carry signal, including cin

// Initialize carry-in
assign c[0] = cin;

// Generate and propagate signals, and calculate carry signals
genvar i;
generate
    for (i = 0; i < 8; i++) begin
        assign g[i] = a[i] & b[i];
        assign p[i] = a[i] | b[i];
        assign c[i+1] = g[i] | (p[i] & c[i]);
    end
endgenerate

// Calculate sum using XOR operation
assign sum = a ^ b ^ c[7:0];

// Calculate carry-out
assign cout = c[8];

endmodule