module adder_8bit (
    input [7:0] a,
    input [7:0] b,
    input cin,
    output [7:0] sum,
    output cout
);

    wire [8:0] carry;  // 9-bit carry (includes cin and cout)
    
    assign carry[0] = cin;
    
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : adder_chain
            assign {carry[i+1], sum[i]} = a[i] + b[i] + carry[i];
        end
    endgenerate
    
    assign cout = carry[8];

endmodule