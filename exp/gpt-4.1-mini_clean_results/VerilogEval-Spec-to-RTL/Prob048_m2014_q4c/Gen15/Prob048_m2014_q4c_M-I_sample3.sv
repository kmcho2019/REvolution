module TopModule (
    input clk,
    input d,
    input r,
    output reg q
);

always @(posedge clk) begin
    if (r) begin
        if (q != 1'b0)
            q <= 1'b0;  // synchronous reset only if q is not already zero
    end else begin
        q <= d;       // normal D flip-flop operation
    end
end

endmodule