module TopModule (
    input clk,
    input a,
    output reg q
);

reg a_prev;  // Previous value of 'a'

always @(posedge clk) begin
    a_prev <= a;  // Store previous value
    
    // Toggle q when detecting rising edge of 'a'
    if (~a_prev && a) begin
        q <= ~q;
    end
end

// Initialize output to 1
initial begin
    q = 1'b1;
    a_prev = 1'b0;
end

endmodule