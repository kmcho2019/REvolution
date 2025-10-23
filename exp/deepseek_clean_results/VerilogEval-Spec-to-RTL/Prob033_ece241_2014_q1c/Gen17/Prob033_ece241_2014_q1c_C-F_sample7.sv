module TopModule(
    input [7:0] a,
    input [7:0] b,
    output [7:0] s,
    output overflow
);
    wire [8:0] carry;
    assign carry[0] = 1'b0;
    
    // Simplified carry computation using generate
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : adder
            wire g = a[i] & b[i];
            wire p = a[i] ^ b[i];
            assign carry[i+1] = g | (p & carry[i]);
            assign s[i] = p ^ carry[i];
        end
    endgenerate
    
    // Optimal overflow detection
    assign overflow = carry[8] ^ carry[7];
endmodule