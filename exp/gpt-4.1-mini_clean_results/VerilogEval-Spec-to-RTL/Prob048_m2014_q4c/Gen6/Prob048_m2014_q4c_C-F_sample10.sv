module TopModule (
    input clk,
    input d,
    input r,
    output reg q
);

wire next_q;
assign next_q = d;

always @(posedge clk) begin
    if (r)
        q <= 1'b0;
    else
        q <= next_q;
end

endmodule