module TopModule (
    input clk,
    input a,
    output reg [2:0] q
);

always @(posedge clk) begin
    if (a) begin
        q <= 3'd4;  // synchronous reset to 4 when a=1
    end else begin
        q <= (q + 1) & 3'b111;  // increment with automatic wrap-around
    end
end

endmodule