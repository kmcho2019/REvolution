module TopModule (
    input clk,
    input a,
    output reg q
);

reg prev_a;

always @(posedge clk) begin
    if (a != prev_a) begin
        q <= ~q;  // Toggle q only when a changes
    end
    prev_a <= a;  // Store current a for next comparison
end

initial begin
    q = 1'b1;     // Initial state
    prev_a = 1'b0; // Initial comparison value
end

endmodule