module TopModule (
    input        clk,
    input        areset,
    input  [7:0] d,
    output reg [7:0] q
);

always @(posedge clk or posedge areset) begin
    if (areset)
        q <= 8'b0;
    else if (d != q)
        q <= d;
    // else retain current q, no unnecessary toggling
end

endmodule