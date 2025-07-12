module TopModule (
    input clk,
    input d,
    input r,
    output reg q
);

always @(posedge clk) begin
    if (r)
        q <= 1'b0;
    else if (q != d)
        q <= d;
    // else no update to avoid toggling
end

endmodule