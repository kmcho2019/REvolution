module TopModule (
    input [1:0] A,
    input [1:0] B,
    output reg z,
    input clk,          // Only used when REGISTERED=1
    input clk_enable    // Clock enable for power optimization
);
    parameter IMPLEMENTATION = 0;  // 0: High-level (==), 1: Gate-level (XNOR)
    parameter REGISTERED = 0;      // 0: Combinational, 1: Registered output
    
    wire z_comb;
    
    generate
        if (IMPLEMENTATION) begin
            // Gate-level implementation (explicit XNOR + AND)
            wire bit0_equal = ~(A[0] ^ B[0]);
            wire bit1_equal = ~(A[1] ^ B[1]);
            assign z_comb = bit0_equal & bit1_equal;
        end else begin
            // High-level implementation (cleaner code)
            assign z_comb = (A == B);
        end
        
        if (REGISTERED) begin
            // Registered version with clock gating
            always @(posedge clk) begin
                if (clk_enable) begin
                    z <= z_comb;
                end
            end
        end else begin
            // Combinational version
            always @(*) begin
                z = z_comb;
            end
        end
    endgenerate
endmodule