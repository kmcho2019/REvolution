module TopModule(
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
    // else no change to q to reduce unnecessary toggling
end

endmodule