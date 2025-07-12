module adder_8bit(
    input   [7:0] a,
    input   [7:0] b,
    input       cin,
    output  [7:0] sum,
    output      cout
);

// Internal signals for carry
wire [7:0] c;
wire [7:0] sum_wire;

// Calculate carry and sum signals
genvar i;
generate
    for (i = 0; i < 8; i++) begin
        if (i == 0) begin
            // First bit
            assign c[i] = (a[i] & b[i]) | (a[i] & cin) | (b[i] & cin);
            assign sum_wire[i] = a[i] ^ b[i] ^ cin;
        end else begin
            // Remaining bits
            assign c[i] = (a[i] & b[i]) | (a[i] & c[i-1]) | (b[i] & c[i-1]);
            assign sum_wire[i] = a[i] ^ b[i] ^ c[i-1];
        end
    end
endgenerate

// Assign sum and cout
assign sum = sum_wire;
assign cout = c[7];

endmodule