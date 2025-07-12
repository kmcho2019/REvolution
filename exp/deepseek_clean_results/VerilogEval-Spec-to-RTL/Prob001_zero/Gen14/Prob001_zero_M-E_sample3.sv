module TopModule (
    input clk,
    output reg zero
);
    initial zero = 1'b1;  // Start at 1 (will underflow to 0)
    
    always @(posedge clk) begin
        zero <= zero - 1'b1;  // Underflow to 0 and stay there
    end
endmodule