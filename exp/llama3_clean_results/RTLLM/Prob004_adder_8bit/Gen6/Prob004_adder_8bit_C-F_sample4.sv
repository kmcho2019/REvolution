module adder_8bit(
    input   [7:0] a,
    input   [7:0] b,
    input       cin,
    output  [7:0] sum,
    output      cout
);

wire [7:0] g;  // Generate signal
wire [7:0] p;  // Propagate signal

// Calculate generate and propagate signals in a loop to reduce code duplication
genvar i;
generate
    for (i = 0; i < 8; i++) begin
        assign g[i] = a[i] & b[i];
        assign p[i] = a[i] | b[i];
    end
endgenerate

// Directly calculate sum and carry-out within a loop
wire [7:0] c;  // Carry signal
assign c[0] = cin;
generate
    for (i = 0; i < 8; i++) begin
        if (i == 0) begin
            assign sum[i] = a[i] ^ b[i] ^ cin;
        end else begin
            assign sum[i] = a[i] ^ b[i] ^ c[i-1];
        end
        
        if (i < 7) begin
            assign c[i+1] = g[i] | (p[i] & c[i]);
        end else begin
            assign cout = g[i] | (p[i] & c[i]);
        end
    end
endgenerate

endmodule