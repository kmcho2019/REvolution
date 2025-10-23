module TopModule (
    input clk,
    input a,
    output reg [2:0] q
);

always @(posedge clk) begin
    if (a) begin
        q <= 3'd4;  // Override when a=1
    end else begin
        q <= (q == 3'd6) ? 3'd0 : q + 1;  // Natural binary counting
    end
end

endmodule