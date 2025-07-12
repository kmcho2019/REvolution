module adder_1bit(
    input   a,
    input   b,
    input   cin,
    output  sum,
    output  cout
);
    
    assign sum = a ^ b ^ cin;
    assign cout = (a & b) | (a & cin) | (b & cin);
    
endmodule

module adder_8bit(
    input   [7:0] a,
    input   [7:0] b,
    input       cin,
    output  [7:0] sum,
    output      cout
);
    
    wire [7:1] c;
    
    adder_1bit u0 (.a(a[0]),.b(b[0]),.cin(cin),.sum(sum[0]),.cout(c[1]));
    
    genvar i;
    generate
        for (i = 1; i < 8; i++) begin
            adder_1bit u(.a(a[i]),.b(b[i]),.cin(c[i]),.sum(sum[i]),.cout(c[i+1]));
        end
    endgenerate
    
    assign cout = c[8];
    
endmodule