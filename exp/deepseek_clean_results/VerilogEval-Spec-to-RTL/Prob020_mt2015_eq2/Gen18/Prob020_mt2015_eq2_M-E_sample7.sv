module TopModule (
    input [1:0] A,
    input [1:0] B,
    output reg z
);
    always @(*) begin
        // Hierarchical comparison with early termination
        if (A[1] != B[1]) begin
            z = 1'b0;  // MSB mismatch - immediate termination
        end
        else begin
            // Only check LSB if MSB matches
            z = (A[0] == B[0]);
        end
    end
endmodule