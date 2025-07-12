module adder_16bit (
    input [15:0] a,
    input [15:0] b,
    input Cin,
    output [15:0] y,
    output Co
);
    wire [16:0] carry;
    
    assign carry[0] = Cin;
    
    // Generate sum and carry in one pass
    assign y = a ^ b ^ carry[15:0];
    assign Co = carry[16];
    
    // Carry generation
    genvar i;
    generate
        for (i = 0; i < 16; i = i + 1) begin : carry_chain
            assign carry[i+1] = (a[i] & b[i]) | ((a[i] | b[i]) & carry[i]);
        end
    endgenerate
endmodule