module TopModule (
    input        clk,
    input        areset,
    input  [7:0] d,
    output reg [7:0] q
);

wire ce = (d != q);

always @(posedge clk or posedge areset) begin
    if (areset)
        q <= 8'b0;
    else if (ce)
        q <= d;
end

endmodule