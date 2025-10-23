module TopModule(
    input clk,
    input a,
    output [2:0] q
);

reg [2:0] q;

always @(posedge clk) begin
    if (a == 1) begin
        // Hold the current value when 'a' is 1
        q <= q;
    end else begin
        // Count up when 'a' is 0
        if (q == 7) begin
            // Reset to 0 after reaching the maximum value 7 (111 in binary)
            q <= 0;
        end else if (q == 0) begin
            // Set to 4 when 'a' transitions from 1 to 0 and q is 0
            q <= 4;
        end else begin
            // Otherwise, just increment the counter
            q <= q + 1;
        end
    end
end

initial begin
    q = 4;
end

endmodule