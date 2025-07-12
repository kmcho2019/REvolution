module adder_8bit #(
    parameter WIDTH = 8
) (
    input [WIDTH-1:0] a,
    input [WIDTH-1:0] b,
    input cin,
    output [WIDTH-1:0] sum,
    output cout
);

    // Group parameters
    localparam GROUP_SIZE = 4;
    localparam NUM_GROUPS = WIDTH/GROUP_SIZE;
    
    // Group propagate and generate signals
    wire [NUM_GROUPS-1:0] Pg, Gg;
    wire [NUM_GROUPS:0] group_carry;
    
    assign group_carry[0] = cin;
    
    // Generate groups
    genvar g;
    generate
        for (g = 0; g < NUM_GROUPS; g = g + 1) begin : group
            // Bit-level signals
            wire [GROUP_SIZE-1:0] P, G;
            wire [GROUP_SIZE:0] carry;
            
            assign carry[0] = group_carry[g];
            
            // Generate bits within group
            genvar i;
            for (i = 0; i < GROUP_SIZE; i = i + 1) begin : bit
                localparam bit_pos = g*GROUP_SIZE + i;
                
                // Propagate and Generate
                assign P[i] = a[bit_pos] ^ b[bit_pos];
                assign G[i] = a[bit_pos] & b[bit_pos];
                
                // Sum
                assign sum[bit_pos] = P[i] ^ carry[i];
                
                // Carry (using majority function)
                assign carry[i+1] = G[i] | (P[i] & carry[i]);
            end
            
            // Group propagate and generate
            assign Pg[g] = &P;  // Group propagates if all bits propagate
            assign Gg[g] = carry[GROUP_SIZE]; // Group generate is final carry
            
            // Next group carry
            assign group_carry[g+1] = Gg[g] | (Pg[g] & group_carry[g]);
        end
    endgenerate
    
    assign cout = group_carry[NUM_GROUPS];

endmodule