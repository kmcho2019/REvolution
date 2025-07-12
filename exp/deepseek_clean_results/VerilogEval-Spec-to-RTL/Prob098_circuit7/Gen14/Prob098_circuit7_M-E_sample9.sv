module TopModule (
    input clk,
    input a,
    output reg q
);

reg a_prev;  // To store previous value of 'a'

always @(posedge clk) begin
    a_prev <= a;  // Capture previous value
    
    // Toggle q only on rising edge of a
    if (~a_prev & a) begin
        q <= ~q;
    end
end

initial begin
    q = 1'b1;  // Initial state to match waveform
    a_prev = 1'b0;
end

endmodule