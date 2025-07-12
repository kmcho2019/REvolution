module adder_8bit_ripple (
    input [7:0] a,
    input [7:0] b,
    input Cin,
    output [7:0] y,
    output Co
);
    wire [8:0] carry;
    
    assign carry[0] = Cin;
    
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : bit_adder
            assign carry[i+1] = (a[i] & b[i]) | ((a[i] | b[i]) & carry[i]);
            assign y[i] = a[i] ^ b[i] ^ carry[i];
        end
    endgenerate
    
    assign Co = carry[8];
endmodule

module adder_8bit_carryselect (
    input [7:0] a,
    input [7:0] b,
    input Cin,
    output [7:0] y,
    output Co
);
    wire [7:0] sum0, sum1;
    wire carry0, carry1;
    
    // Compute both possible cases in parallel
    adder_8bit_ripple adder0 (
        .a(a),
        .b(b),
        .Cin(1'b0),
        .y(sum0),
        .Co(carry0)
    );
    
    adder_8bit_ripple adder1 (
        .a(a),
        .b(b),
        .Cin(1'b1),
        .y(sum1),
        .Co(carry1)
    );
    
    // Select correct result based on actual carry-in
    assign y = Cin ? sum1 : sum0;
    assign Co = Cin ? carry1 : carry0;
endmodule

module adder_16bit (
    input [15:0] a,
    input [15:0] b,
    input Cin,
    output [15:0] y,
    output Co
);
    wire carry_middle;
    
    // Lower 8-bit uses ripple carry
    adder_8bit_ripple adder_low (
        .a(a[7:0]),
        .b(b[7:0]),
        .Cin(Cin),
        .y(y[7:0]),
        .Co(carry_middle)
    );
    
    // Upper 8-bit uses carry-select
    adder_8bit_carryselect adder_high (
        .a(a[15:8]),
        .b(b[15:8]),
        .Cin(carry_middle),
        .y(y[15:8]),
        .Co(Co)
    );
endmodule