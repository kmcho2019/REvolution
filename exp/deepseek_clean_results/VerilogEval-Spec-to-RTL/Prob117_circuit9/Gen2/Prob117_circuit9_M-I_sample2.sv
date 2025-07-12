module TopModule (
    input clk,
    input a,
    output reg [2:0] q = 3'd4  // initialize to 4
);

always @(posedge clk) begin
    if (a) begin
        q <= q;  // hold value when a=1
    end else begin
        q <= q + 1;  // increment with natural 3-bit wrap-around
    end
end

endmodule