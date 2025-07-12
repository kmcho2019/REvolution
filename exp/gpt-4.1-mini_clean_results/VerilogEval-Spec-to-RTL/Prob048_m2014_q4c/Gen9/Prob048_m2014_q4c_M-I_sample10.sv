module TopModule (
    input clk,
    input d,
    input r,
    output reg q
);

always @(posedge clk) begin
    if (r)
        q <= 1'b0;  // synchronous reset active
    else
        q <= d;     // normal D flip-flop operation
end

endmodule