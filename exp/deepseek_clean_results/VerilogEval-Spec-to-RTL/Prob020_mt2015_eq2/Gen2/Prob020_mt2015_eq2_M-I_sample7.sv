module TopModule (
    input [1:0] A,
    input [1:0] B,
    output reg z  // Changed to reg for optional registered version
);

    // Most efficient version (combinational)
    // assign z = (A == B);
    
    // Optional registered version for better timing in high-frequency designs
    always @(*) begin
        z = (A == B);
    end
    
    // For actual registered version (uncomment if needed):
    // always @(posedge clk) begin
    //     z <= (A == B);
    // end

endmodule