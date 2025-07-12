module adder_bcd (
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

    // Binary addition including carry-in
    wire [4:0] binary_sum = A + B + Cin;
    
    // Optimized BCD correction detection:
    // Sum >9 when either:
    // - There's a carry out (binary_sum[4] is set), OR
    // - The sum has bits 3&2 set (12-15), OR
    // - The sum has bits 3&1 set (10-11)
    wire needs_correction = binary_sum[4] | 
                          (binary_sum[3] & (binary_sum[2] | binary_sum[1]));
    
    // Apply correction using multiplexer instead of adder
    assign {Cout, Sum} = needs_correction ? 
                        {1'b1, binary_sum[3:0] + 4'd6} : 
                        binary_sum;

endmodule