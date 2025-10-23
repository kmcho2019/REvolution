/**
 * Optimized 8-bit Carry-Lookahead Adder with parameterized width
 * Implements combinational addition with 4-bit carry-lookahead groups
 * Optional pipeline registers for high-speed operation
 */
module adder_8bit #(
    parameter WIDTH = 8,     // Default to 8-bit width
    parameter PIPELINED = 0  // Enable pipeline registers
) (
    input [WIDTH-1:0] a,    // Operand A
    input [WIDTH-1:0] b,    // Operand B
    input cin,              // Carry-in
    output [WIDTH-1:0] sum, // Sum output
    output cout             // Carry-out
);

    // Carry generate and propagate signals
    wire [WIDTH-1:0] g, p;
    wire [WIDTH:0] carry;
    
    // Generate and propagate computation
    assign g = a & b;  // Generate
    assign p = a ^ b;  // Propagate
    
    // Carry computation (4-bit lookahead groups)
    assign carry[0] = cin;
    
    // First 4-bit group
    assign carry[1] = g[0] | (p[0] & carry[0]);
    assign carry[2] = g[1] | (p[1] & g[0]) | (p[1] & p[0] & carry[0]);
    assign carry[3] = g[2] | (p[2] & g[1]) | (p[2] & p[1] & g[0]) | 
                     (p[2] & p[1] & p[0] & carry[0]);
    assign carry[4] = g[3] | (p[3] & g[2]) | (p[3] & p[2] & g[1]) |
                     (p[3] & p[2] & p[1] & g[0]) | 
                     (p[3] & p[2] & p[1] & p[0] & carry[0]);
    
    // Second 4-bit group
    assign carry[5] = g[4] | (p[4] & carry[4]);
    assign carry[6] = g[5] | (p[5] & g[4]) | (p[5] & p[4] & carry[4]);
    assign carry[7] = g[6] | (p[6] & g[5]) | (p[6] & p[5] & g[4]) | 
                     (p[6] & p[5] & p[4] & carry[4]);
    assign carry[8] = g[7] | (p[7] & g[6]) | (p[7] & p[6] & g[5]) |
                     (p[7] & p[6] & p[5] & g[4]) | 
                     (p[7] & p[6] & p[5] & p[4] & carry[4]);
    
    // Sum computation
    assign sum = p ^ carry[WIDTH-1:0];
    assign cout = carry[WIDTH];
    
    // Optional pipeline registers
    generate
        if (PIPELINED) begin
            reg [WIDTH-1:0] sum_reg;
            reg cout_reg;
            
            always @(posedge clk) begin
                sum_reg <= sum;
                cout_reg <= cout;
            end
            
            assign sum = sum_reg;
            assign cout = cout_reg;
        end
    endgenerate

    // Operand isolation (power optimization)
    generate
        if (POWER_OPT) begin
            wire [WIDTH-1:0] a_iso = enable ? a : '0;
            wire [WIDTH-1:0] b_iso = enable ? b : '0;
            wire cin_iso = enable ? cin : '0;
        end
    endgenerate

endmodule