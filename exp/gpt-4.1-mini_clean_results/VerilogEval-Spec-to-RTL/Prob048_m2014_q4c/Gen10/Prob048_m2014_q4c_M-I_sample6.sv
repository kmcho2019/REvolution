module TopModule (
    input clk,
    input d,
    input r,
    output reg q
);

always @(posedge clk) begin
    if (r) begin
        if (q != 1'b0)
            q <= 1'b0;
    end else begin
        if (q != d)
            q <= d;
    end
end

endmodule