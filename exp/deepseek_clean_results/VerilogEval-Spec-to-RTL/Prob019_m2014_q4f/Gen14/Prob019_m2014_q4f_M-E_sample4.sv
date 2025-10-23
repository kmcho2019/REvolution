module TopModule (
    input in1,
    input in2,
    output reg out
);
    reg phase;
    reg saved_in1, saved_in2_n;
    
    always @(posedge phase) begin
        // Phase 1: Sample inputs and compute in2_n
        saved_in1 <= in1;
        saved_in2_n <= ~in2;
    end
    
    always @(negedge phase) begin
        // Phase 2: Compute AND operation
        out <= saved_in1 & saved_in2_n;
    end
    
    always begin
        #5 phase = ~phase;  // Internal oscillator for evaluation phases
    end
    
    initial begin
        phase = 0;
        out = 0;
    end
endmodule