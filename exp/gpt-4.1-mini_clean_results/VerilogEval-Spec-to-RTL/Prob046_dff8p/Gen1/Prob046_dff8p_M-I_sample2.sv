module TopModule (
    input        clk,
    input        reset,
    input  [7:0] d,
    output reg [7:0] q
);

reg [7:0] d_prev;

wire load_enable = reset || (d != d_prev);

always @(negedge clk) begin
    if (reset)
        q <= 8'h34;
    else if (load_enable)
        q <= d;
    // else retain q to avoid unnecessary toggling
end

always @(posedge clk) begin
    d_prev <= d;
end

endmodule