module TopModule(
    input  [7:0] a,  
    input  [7:0] b,  
    output [7:0] s,  
    output      overflow  
);

    // Internal wires for the carry
    wire [8:0] c;

    // Initialize the carry-in for the LSB
    assign c[0] = 1'b0;

    // Calculate the sum and the carry-out for each bit position
    genvar i;
    generate
        for (i = 0; i < 8; i++) begin
            assign s[i] = a[i] ^ b[i] ^ c[i];
            assign c[i+1] = (a[i] & b[i]) | (a[i] & c[i]) | (b[i] & c[i]);
        end
    endgenerate

    // Overflow detection
    assign overflow = (a[7] == b[7] && a[7]!= s[7]);

endmodule