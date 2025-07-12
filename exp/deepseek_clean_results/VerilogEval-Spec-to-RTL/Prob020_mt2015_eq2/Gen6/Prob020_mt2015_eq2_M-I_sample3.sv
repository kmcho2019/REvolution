module TopModule (
    input [1:0] A,
    input [1:0] B,
    output reg z  // Changed to reg for potential registered output
);
    parameter REGISTER_OUTPUT = 0;  // 0: combinational, 1: registered
    
    wire z_comb = (A == B);  // More readable equality comparison
    
    generate
        if (REGISTER_OUTPUT) begin
            always @(posedge clk) begin
                z <= z_comb;
            end
        end else begin
            always @(*) begin
                z = z_comb;
            end
        end
    endgenerate
endmodule