module TopModule(
    input clk,
    input a,
    output [2:0] q
);

reg [2:0] q;

always @(posedge clk) begin
    if (a) begin
        q <= 3'd4; // Reset to 4 when a is high
    end else begin
        if (q == 3'd7) begin
            q <= 3'd0; // Wrap around to 0 after 7
        end else begin
            q <= q + 1; // Increment q when a is low
        end
    end
end

endmodule