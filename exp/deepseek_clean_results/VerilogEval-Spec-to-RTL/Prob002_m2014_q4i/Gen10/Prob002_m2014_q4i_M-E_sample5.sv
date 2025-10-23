module TopModule (
    output reg out
);
    always @(posedge 1'b0) begin  // Using constant 0 as clock for demonstration
        out <= 1'b0;             // Will only trigger once at time 0
    end
    
    initial begin
        out = 1'b0;              // Initialize to 0
    end
endmodule