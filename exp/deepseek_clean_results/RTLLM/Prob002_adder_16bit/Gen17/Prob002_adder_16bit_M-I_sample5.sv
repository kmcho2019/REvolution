module adder_4bit (
    input [3:0] a,
    input [3:0] b,
    input cin,
    output [3:0] sum,
    output cout
);
    wire [4:0] carry;
    assign carry[0] = cin;
    
    // Carry generation
    genvar i;
    generate
        for (i = 0; i < 4; i = i + 1) begin : carry_chain
            assign carry[i+1] = (a[i] & b[i]) | ((a[i] | b[i]) & carry[i]);
        end
    endgenerate
    
    // Sum calculation
    assign sum = a ^ b ^ carry[3:0];
    assign cout = carry[4];
endmodule

module adder_8bit (
    input [7:0] a,
    input [7:0] b,
    input cin,
    output [7:0] sum,
    output cout
);
    wire carry_mid;
    wire [7:0] sum0, sum1;
    
    // Generate both possible sums (cin=0 and cin=1)
    adder_4bit adder_low0 (.a(a[3:0]), .b(b[3:0]), .cin(1'b0), .sum(sum0[3:0]), .cout());
    adder_4bit adder_high0 (.a(a[7:4]), .b(b[7:4]), .cin(1'b0), .sum(sum0[7:4]), .cout());
    
    adder_4bit adder_low1 (.a(a[3:0]), .b(b[3:0]), .cin(1'b1), .sum(sum1[3:0]), .cout(carry_mid));
    adder_4bit adder_high1 (.a(a[7:4]), .b(b[7:4]), .cin(carry_mid), .sum(sum1[7:4]), .cout());
    
    // Mux the correct sum based on actual carry-in
    assign sum = cin ? sum1 : sum0;
    
    // Carry-out selection
    assign cout = (sum0[7:4] == sum1[7:4]) ? 
                 (cin ? carry_mid : 1'b0) : 
                 (cin ? sum1[7] : sum0[7]);
endmodule

module adder_16bit (
    input [15:0] a,
    input [15:0] b,
    input Cin,
    output [15:0] y,
    output Co
);
    wire carry_mid;
    
    // Instantiate lower 8-bit carry-select adder
    adder_8bit adder_low (
        .a(a[7:0]),
        .b(b[7:0]),
        .cin(Cin),
        .sum(y[7:0]),
        .cout(carry_mid)
    );
    
    // Instantiate upper 8-bit carry-select adder
    adder_8bit adder_high (
        .a(a[15:8]),
        .b(b[15:8]),
        .cin(carry_mid),
        .sum(y[15:8]),
        .cout(Co)
    );
endmodule