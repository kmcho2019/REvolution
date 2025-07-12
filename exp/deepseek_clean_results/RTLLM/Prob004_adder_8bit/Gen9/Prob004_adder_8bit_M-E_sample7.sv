module adder_8bit (
    input [7:0] a,
    input [7:0] b,
    input cin,
    output [7:0] sum,
    output cout
);

    // Lower 4-bit ripple-carry adder
    wire [3:0] sum_low;
    wire carry_low;
    
    // Carry chain for lower 4 bits
    wire [4:0] carry_chain_low;
    assign carry_chain_low[0] = cin;
    
    genvar i;
    generate
        for (i = 0; i < 4; i = i + 1) begin : low_adder
            assign sum_low[i] = a[i] ^ b[i] ^ carry_chain_low[i];
            assign carry_chain_low[i+1] = (a[i] & b[i]) | (carry_chain_low[i] & (a[i] | b[i]));
        end
    endgenerate
    assign carry_low = carry_chain_low[4];
    
    // Upper 4-bit carry-select adder
    wire [3:0] sum_high_0, sum_high_1;  // Sums for carry=0 and carry=1 cases
    wire carry_high_0, carry_high_1;
    
    // Upper adder assuming carry-in=0
    wire [4:0] carry_chain_high_0;
    assign carry_chain_high_0[0] = 1'b0;
    generate
        for (i = 4; i < 8; i = i + 1) begin : high_adder_0
            assign sum_high_0[i-4] = a[i] ^ b[i] ^ carry_chain_high_0[i-4];
            assign carry_chain_high_0[i-3] = (a[i] & b[i]) | (carry_chain_high_0[i-4] & (a[i] | b[i]));
        end
    endgenerate
    assign carry_high_0 = carry_chain_high_0[4];
    
    // Upper adder assuming carry-in=1
    wire [4:0] carry_chain_high_1;
    assign carry_chain_high_1[0] = 1'b1;
    generate
        for (i = 4; i < 8; i = i + 1) begin : high_adder_1
            assign sum_high_1[i-4] = a[i] ^ b[i] ^ carry_chain_high_1[i-4];
            assign carry_chain_high_1[i-3] = (a[i] & b[i]) | (carry_chain_high_1[i-4] & (a[i] | b[i]));
        end
    endgenerate
    assign carry_high_1 = carry_chain_high_1[4];
    
    // Select appropriate upper result based on lower carry
    assign sum[7:4] = carry_low ? sum_high_1 : sum_high_0;
    assign sum[3:0] = sum_low;
    assign cout = carry_low ? carry_high_1 : carry_high_0;

endmodule