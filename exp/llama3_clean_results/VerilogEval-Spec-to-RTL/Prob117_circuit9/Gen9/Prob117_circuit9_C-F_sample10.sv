module TopModule(
    input clk,
    input a,
    output reg [2:0] q
);

always @(posedge clk) begin
    if (a) begin
        // Reset to 4 when 'a' is high
        q <= 4;
    end else begin
        // Increment or wrap around when 'a' is low
        q <= (q == 6)? 0 : q + 1;
    end
end

endmodule