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
        for (i = 0; i < 8; i = i + 1) begin : adder_loop
            assign sum[i] = a[i] ^ b[i] ^ carry[i];
            assign carry[i+1] = (a[i] & b[i]) | (a[i] & carry[i]) | (b[i] & carry[i]);
        end
    endgenerate
    
    assign Cout = carry[8];
endmodule

module carry_select_8bit (
    input [7:0] a,
    input [7:0] b,
    input Cin,
    output [7:0] sum,
    output Cout
);
    wire [7:0] sum0, sum1;
    wire cout0, cout1;
    
    // Compute both possible cases in parallel
    ripple_adder_8bit adder0 (
        .a(a),
        .b(b),
        .Cin(1'b0),
        .sum(sum0),
        .Cout(cout0)
    );
    
    ripple_adder_8bit adder1 (
        .a(a),
        .b(b),
        .Cin(1'b1),
        .sum(sum1),
        .Cout(cout1)
    );
    
    // Select the correct result based on actual carry-in
    assign sum = Cin ? sum1 : sum0;
    assign Cout = Cin ? cout1 : cout0;
endmodule

module adder_16bit (
    input [15:0] a,
    input [15:0] b,
    input Cin,
    output [15:0] y,
    output Co
);
    wire carry_middle;
    
    // Lower 8 bits - ripple carry adder
    ripple_adder_8bit adder_low (
        .a(a[7:0]),
        .b(b[7:0]),
        .Cin(Cin),
        .sum(y[7:0]),
        .Cout(carry_middle)
    );
    
    // Upper 8 bits - carry select adder
    carry_select_8bit adder_high (
        .a(a[15:8]),
        .b(b[15:8]),
        .Cin(carry_middle),
        .sum(y[15:8]),
        .Cout(Co)
    );
endmodule