module TopModule(
    input clk,
    input a,
    output reg [2:0] q
);

always @(posedge clk) begin
    if (a) begin
        q <= 4;  // Load value when a is 1
    end else begin
        if (q == 7) begin  // Assuming 3-bit counter, max value is 7 (111)
            q <= 0;  // Reset counter if it overflows
        end else begin
            q <= q + 1;  // Increment counter when a is 0
        end
    end
end

endmodule