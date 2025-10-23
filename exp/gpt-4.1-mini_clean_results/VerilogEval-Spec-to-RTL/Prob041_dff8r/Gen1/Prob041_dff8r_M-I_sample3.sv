module TopModule(
    input        clk,
    input        reset,
    input  [7:0] d,
    output reg [7:0] q
);

wire ce = reset || (q != d);

always @(posedge clk) begin
    if (reset)
        q <= 8'b0;
    else if (ce)
        q <= d;
end

endmodule