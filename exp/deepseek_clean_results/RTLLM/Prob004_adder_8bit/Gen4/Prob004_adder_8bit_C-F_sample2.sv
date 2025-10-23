module adder_8bit (
    input [7:0] a,
    input [7:0] b,
    input cin,
    output [7:0] sum,
    output cout
);

    wire [8:0] carry;  // Carry chain (bit 0 to 8)
    
    // Handle first bit explicitly for clarity
    assign sum[0] = a[0] ^ b[0] ^ cin;
    assign carry[1] = (a[0] & b[0]) | (a[0] & cin) | (b[0] & cin);
    
    // Generate remaining bits efficiently
    genvar i;
    generate
        for (i = 1; i < 7; i = i + 1) begin : adder_chain
            assign sum[i] = a[i] ^ b[i] ^ carry[i];
            assign carry[i+1] = (a[i] & b[i]) | (a[i] & carry[i]) | (b[i] & carry[i]);
        end
    endgenerate
    
    // Handle last bit explicitly to connect to cout
    assign sum[7] = a[7] ^ b[7] ^ carry[7];
    assign cout = (a[7] & b[7]) | (a[7] & carry[7]) | (b[7] & carry[7]);

endmodule