module TopModule (
    input  clk,
    input  ar,   // Asynchronous active-high reset
    input  d,
    output reg q
);

wire clk_en;
// Enable clock only when not in reset and input d differs from q
assign clk_en = ~ar & (d ^ q);

always @(posedge clk or posedge ar) begin
    if (ar)
        q <= 1'b0;
    else if (clk_en)
        q <= d;
    else
        q <= q;  // Hold current state to avoid unnecessary toggling
end

endmodule