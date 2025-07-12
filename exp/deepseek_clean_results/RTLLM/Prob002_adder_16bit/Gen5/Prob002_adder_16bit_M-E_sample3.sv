module ripple_adder_8bit (
    input [7:0] a,
    input [7:0] b,
    input Cin,
    output [7:0] sum,
    output Cout
);
    wire [8:0] carry;
    assign carry[0] = Cin;
    
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : bit_adder
            assign sum[i] = a[i] ^ b[i] ^ carry[i];
            assign carry[i+1] = (a[i] & b[i]) | (a[i] & carry[i]) | (b[i] & carry[i]);
        end
    endgenerate
    
    assign Cout = carry[8];
endmodule

module adder_16bit (
    input [15:0] a,
    input [15:0] b,
    input Cin,
    output [15:0] y,
    output Co
);
    // Lower 8 bits - ripple carry adder
    wire carry_middle;
    ripple_adder_8bit lower_adder (
        .a(a[7:0]),
        .b(b[7:0]),
        .Cin(Cin),
        .sum(y[7:0]),
        .Cout(carry_middle)
    );
    
    // Upper 8 bits - carry select adder
    wire [7:0] sum0, sum1;
    wire cout0, cout1;
    
    // Compute both possible cases for upper bits
    ripple_adder_8bit upper_adder0 (
        .a(a[15:8]),
        .b(b[15:8]),
        .Cin(1'b0),
        .sum(sum0),
        .Cout(cout0)
    );
    
    ripple_adder_8bit upper_adder1 (
        .a(a[15:8]),
        .b(b[15:8]),
        .Cin(1'b1),
        .sum(sum1),
        .Cout(cout1)
    );
    
    // Select correct result based on actual carry from lower bits
    assign y[15:8] = carry_middle ? sum1 : sum0;
    assign Co = carry_middle ? cout1 : cout0;
endmodule