module TopModule (
    input clk,    // System clock
    input a,      // Input signal
    output reg q  // Registered output
);

reg a_prev;       // Stores previous value of a

always @(posedge clk) begin
    a_prev <= a;  // Store current a value
    
    // Update q only when a changes
    if (a_prev != a) begin
        q <= ~q;
    end
end

// Initialize outputs (simulation only)
initial begin
    q = 1'b0;
    a_prev = 1'b0;
end

endmodule