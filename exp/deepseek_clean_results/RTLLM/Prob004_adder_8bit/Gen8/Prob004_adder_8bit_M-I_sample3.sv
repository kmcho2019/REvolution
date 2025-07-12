module adder_8bit #(
    parameter WIDTH = 8
) (
    input [WIDTH-1:0] a,
    input [WIDTH-1:0] b,
    input cin,
    output [WIDTH-1:0] sum,
    output cout
);

    // Group size for carry lookahead (optimal for 8-bit adder)
    localparam GROUP_SIZE = 4;
    
    // Generate and propagate signals for each bit
    wire [WIDTH-1:0] g, p;
    assign g = a & b;  // Generate
    assign p = a | b;  // Propagate
    
    // First level carry computation (4-bit groups)
    wire [1:0] gg, pg;  // Group generate/propagate
    wire [1:0] group_carry;
    
    // Group 0 (bits 0-3)
    assign gg[0] = g[3] | (p[3] & (g[2] | (p[2] & (g[1] | (p[1] & g[0])))));
    assign pg[0] = p[3] & p[2] & p[1] & p[0];
    
    // Group 1 (bits 4-7)
    assign gg[1] = g[7] | (p[7] & (g[6] | (p[6] & (g[5] | (p[5] & g[4])))));
    assign pg[1] = p[7] & p[6] & p[5] & p[4];
    
    // Second level carry computation
    assign group_carry[0] = cin;
    assign group_carry[1] = gg[0] | (pg[0] & group_carry[0]);
    assign cout = gg[1] | (pg[1] & group_carry[1]);
    
    // Bit-level sum and carry computation
    wire [WIDTH:0] carry;
    assign carry[0] = cin;
    
    genvar i;
    generate
        for (i = 0; i < WIDTH; i = i + 1) begin : bit_adder
            // Local carry computation
            if (i % GROUP_SIZE == 0) begin
                assign carry[i+1] = group_carry[i/GROUP_SIZE];
            end else begin
                assign carry[i+1] = g[i] | (p[i] & carry[i]);
            end
            
            // Sum computation
            assign sum[i] = a[i] ^ b[i] ^ carry[i];
        end
    endgenerate

endmodule