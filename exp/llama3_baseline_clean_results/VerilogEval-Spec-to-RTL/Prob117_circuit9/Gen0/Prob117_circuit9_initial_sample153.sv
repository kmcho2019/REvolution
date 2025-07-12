module TopModule(
    input clk,
    input a,
    output [2:0] q
);

reg [2:0] q;

always @(posedge clk) begin
    if (a) begin
        if (q == 0) begin
            q <= 4;  // Load 4 on first rising edge of clk when a is high
        end else begin
            q <= 4;  // Keep q at 4 as long as a is high
        end
    end else begin
        if (q == 7) begin  // Since q is 3 bits, 7 will be represented as 111
            q <= 0;  // Wrap around to 0
        end else begin
            q <= q + 1;  // Increment counter
        end
    end
end

endmodule