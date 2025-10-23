module adder_8bit #(
    parameter WIDTH = 8  // Makes the design scalable to other bit widths
) (
    input [WIDTH-1:0] a,  // First operand
    input [WIDTH-1:0] b,  // Second operand
    input cin,            // Carry-in
    output [WIDTH-1:0] sum,  // Sum output
    output cout           // Carry-out
);

    // Carry chain (WIDTH+1 bits to include cin and cout)
    wire [WIDTH:0] carry;
    assign carry[0] = cin;

    // Generate full adders for each bit
    genvar i;
    generate
        for (i = 0; i < WIDTH; i = i + 1) begin : adder_chain
            // Sum bit (XOR of inputs and carry)
            assign sum[i] = a[i] ^ b[i] ^ carry[i];
            
            // Carry-out bit (majority function)
            assign carry[i+1] = (a[i] & b[i]) | (carry[i] & (a[i] ^ b[i]));
        end
    endgenerate

    // Final carry-out assignment
    assign cout = carry[WIDTH];

endmodule