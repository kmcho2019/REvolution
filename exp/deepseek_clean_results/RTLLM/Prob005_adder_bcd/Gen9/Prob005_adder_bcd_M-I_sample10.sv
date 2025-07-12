module adder_bcd (
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

    // Carry-select adder structure
    wire [4:0] sum0 = A + B + Cin;      // Sum without correction
    wire [4:0] sum1 = sum0 + 5'd6;      // Sum with correction
    
    // Optimized overflow detection (3 gates)
    wire needs_correction = (sum0[3:1] >= 3'd5) | (sum0[4]);
    
    // Select appropriate sum and carry
    assign {Cout, Sum} = needs_correction ? sum1 : sum0;
    
endmodule