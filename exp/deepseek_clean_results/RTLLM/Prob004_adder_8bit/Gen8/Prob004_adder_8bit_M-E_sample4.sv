module adder_8bit (
    input [7:0] a,
    input [7:0] b,
    input cin,
    output [7:0] sum,
    output cout
);

    // Lower 4-bit ripple adder (bits 3:0)
    wire [3:0] sum_low;
    wire [4:0] carry_low;
    assign carry_low[0] = cin;
    
    genvar i;
    generate
        for (i = 0; i < 4; i = i + 1) begin : low_adder
            assign sum_low[i] = a[i] ^ b[i] ^ carry_low[i];
            assign carry_low[i+1] = (a[i] & b[i]) | 
                                   (carry_low[i] & (a[i] | b[i]));
        end
    endgenerate

    // Upper 4-bit carry-select with prediction
    wire [3:0] sum_high_0, sum_high_1;  // Possible upper sums
    wire [4:0] carry_high_0, carry_high_1;
    
    // Compute both possible upper sums
    assign carry_high_0[0] = 1'b0;
    assign carry_high_1[0] = 1'b1;
    
    generate
        for (i = 4; i < 8; i = i + 1) begin : high_adder
            localparam j = i - 4;
            // Sum assuming carry-in 0
            assign sum_high_0[j] = a[i] ^ b[i] ^ carry_high_0[j];
            assign carry_high_0[j+1] = (a[i] & b[i]) | 
                                     (carry_high_0[j] & (a[i] | b[i]));
            
            // Sum assuming carry-in 1
            assign sum_high_1[j] = a[i] ^ b[i] ^ carry_high_1[j];
            assign carry_high_1[j+1] = (a[i] & b[i]) | 
                                     (carry_high_1[j] & (a[i] | b[i]));
        end
    endgenerate

    // Carry prediction logic
    wire group_propagate = &(a[3:0] | b[3:0]);  // All bits propagate
    wire group_generate = |(a[3:0] & b[3:0]);   // Any bit generates
    wire carry_predicted = group_generate | (group_propagate & cin);

    // Output selection
    assign sum = {carry_predicted ? sum_high_1 : sum_high_0, sum_low};
    assign cout = carry_predicted ? carry_high_1[4] : carry_high_0[4];

endmodule