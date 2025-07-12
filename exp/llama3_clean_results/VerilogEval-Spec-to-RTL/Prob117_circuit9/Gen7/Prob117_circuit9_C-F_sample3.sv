module TopModule(
    input clk,
    input a,
    output reg [2:0] q
);

always @(posedge clk) begin
    if (a) begin
        q <= 4; // Reset to 4 when a is high
    end else begin
        q <= (q == 6) ? 0 : q + 1; // Increment or wrap around when a is low
    end
end

endmodule