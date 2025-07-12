module adder_8bit (
    input  wire [7:0] a,     // 8-bit input operand A
    input  wire [7:0] b,     // 8-bit input operand B
    input  wire       cin,   // Carry-in input
    output wire [7:0] sum,   // 8-bit sum output
    output wire       cout   // Carry-out output
);

    wire [7:0] generate; // Generate signals for each bit
    wire [7:0] propagate; // Propagate signals for each bit
    wire [8:0] carry; // Carry signals including cin and cout

    assign carry[0] = cin;

    // Generate and propagate signals for each bit
    assign generate = a & b;       // bitwise generate: 1 if both a and b are 1
    assign propagate = a ^ b;      // bitwise propagate: 1 if either a or b is 1 but not both

    // Carry computation using carry-lookahead style:
    // carry[i+1] = generate[i] | (propagate[i] & carry[i])
    assign carry[1] = generate[0] | (propagate[0] & carry[0]);
    assign carry[2] = generate[1] | (propagate[1] & carry[1]);
    assign carry[3] = generate[2] | (propagate[2] & carry[2]);
    assign carry[4] = generate[3] | (propagate[3] & carry[3]);
    assign carry[5] = generate[4] | (propagate[4] & carry[4]);
    assign carry[6] = generate[5] | (propagate[5] & carry[5]);
    assign carry[7] = generate[6] | (propagate[6] & carry[6]);
    assign carry[8] = generate[7] | (propagate[7] & carry[7]);

    // Sum is propagate XOR carry-in for each bit
    assign sum = propagate ^ carry[7:0];
    assign cout = carry[8];

endmodule