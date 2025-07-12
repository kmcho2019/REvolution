module adder_8bit (
    input [7:0] a,
    input [7:0] b,
    input cin,
    output [7:0] sum,
    output cout
);

    wire [7:0] carry;  // Carry between bits
    
    // First bit with cin (explicit for clarity)
    assign {carry[0], sum[0]} = a[0] + b[0] + cin;
    
    // Middle bits (using generate for scalability)
    genvar i;
    generate
        for (i = 1; i < 7; i = i + 1) begin : adder_chain
            assign {carry[i], sum[i]} = a[i] + b[i] + carry[i-1];
        end
    endgenerate
    
    // Last bit with cout (explicit for clarity)
    assign {cout, sum[7]} = a[7] + b[7] + carry[6];

endmodule