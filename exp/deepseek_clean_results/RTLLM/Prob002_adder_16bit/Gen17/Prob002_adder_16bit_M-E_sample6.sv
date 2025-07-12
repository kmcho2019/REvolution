// 4-bit ripple carry adder (base component)
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
        for (i = 0; i < 4; i = i + 1) begin
            assign carry[i+1] = (a[i] & b[i]) | ((a[i] | b[i]) & carry[i]);
        end
    endgenerate
    
    // Sum calculation
    assign sum = a ^ b ^ carry[3:0];
    assign cout = carry[4];
endmodule

// 16-bit carry-select adder
module adder_16bit (
    input [15:0] a,
    input [15:0] b,
    input Cin,
    output [15:0] y,
    output Co
);
    wire [3:0] carry;
    wire [3:0] sum0 [3:0]; // Sum assuming carry-in 0
    wire [3:0] sum1 [3:0]; // Sum assuming carry-in 1
    wire cout0 [3:0];      // Cout assuming carry-in 0
    wire cout1 [3:0];      // Cout assuming carry-in 1
    
    assign carry[0] = Cin;
    
    // Generate 4-bit blocks with both carry possibilities
    genvar block;
    generate
        for (block = 0; block < 4; block = block + 1) begin
            // Block with carry-in 0
            adder_4bit adder0 (
                .a(a[block*4+3:block*4]),
                .b(b[block*4+3:block*4]),
                .cin(1'b0),
                .sum(sum0[block]),
                .cout(cout0[block])
            );
            
            // Block with carry-in 1
            adder_4bit adder1 (
                .a(a[block*4+3:block*4]),
                .b(b[block*4+3:block*4]),
                .cin(1'b1),
                .sum(sum1[block]),
                .cout(cout1[block])
            );
            
            // Carry select mux
            assign y[block*4+3:block*4] = carry[block] ? sum1[block] : sum0[block];
            
            // Carry chain
            if (block < 3) begin
                assign carry[block+1] = carry[block] ? cout1[block] : cout0[block];
            end
        end
    endgenerate
    
    // Final carry out
    assign Co = carry[3] ? cout1[3] : cout0[3];
endmodule