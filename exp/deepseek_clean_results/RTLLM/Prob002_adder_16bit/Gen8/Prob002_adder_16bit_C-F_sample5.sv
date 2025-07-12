module adder_8bit (
    input [7:0] a,
    input [7:0] b,
    input Cin,
    output [7:0] y,
    output Co
);
    // Named carry chain for better debugging
    wire c0, c1, c2, c3, c4, c5, c6;
    
    // First bit (special case for Cin)
    assign y[0] = a[0] ^ b[0] ^ Cin;
    assign c0 = (a[0] & b[0]) | ((a[0] | b[0]) & Cin);  // Optimized carry expression
    
    // Middle bits using generate for compactness
    genvar i;
    generate
        for (i = 1; i < 7; i = i + 1) begin : adder_loop
            assign y[i] = a[i] ^ b[i] ^ ((i == 1) ? c0 : 
                                        (i == 2) ? c1 :
                                        (i == 3) ? c2 :
                                        (i == 4) ? c3 :
                                        (i == 5) ? c4 : c5);
            // Grouped carry logic for better optimization
            wire temp_carry;
            assign temp_carry = (i == 1) ? c0 : 
                               (i == 2) ? c1 :
                               (i == 3) ? c2 :
                               (i == 4) ? c3 :
                               (i == 5) ? c4 : c5;
            assign {c1, c2, c3, c4, c5, c6}[i-1] = (a[i] & b[i]) | ((a[i] | b[i]) & temp_carry);
        end
    endgenerate
    
    // Last bit (special case for Co)
    assign y[7] = a[7] ^ b[7] ^ c6;
    assign Co = (a[7] & b[7]) | ((a[7] | b[7]) & c6);  // Optimized carry expression
endmodule

module adder_16bit (
    input [15:0] a,
    input [15:0] b,
    input Cin,
    output [15:0] y,
    output Co
);
    // Explicitly named intermediate carry for clarity
    wire low_to_high_carry;
    
    // Lower 8 bits
    adder_8bit adder_low (
        .a(a[7:0]),
        .b(b[7:0]),
        .Cin(Cin),
        .y(y[7:0]),
        .Co(low_to_high_carry)
    );
    
    // Upper 8 bits
    adder_8bit adder_high (
        .a(a[15:8]),
        .b(b[15:8]),
        .Cin(low_to_high_carry),
        .y(y[15:8]),
        .Co(Co)
    );
endmodule