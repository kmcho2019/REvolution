module TopModule (
    input clk,
    output reg zero
);
    initial zero = 1'b1; // Start high (will immediately go low)
    
    always @(posedge clk) begin
        zero <= zero - 1'b1; // Will count down to 0 and stay there
    end
endmodule