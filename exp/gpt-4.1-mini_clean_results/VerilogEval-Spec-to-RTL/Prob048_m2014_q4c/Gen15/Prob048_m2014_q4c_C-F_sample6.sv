module TopModule (
    input  wire clk,
    input  wire d,
    input  wire r,
    output reg  q
);

always @(posedge clk) begin
    if (r)
        q <= 1'b0;  // synchronous reset
    else
        q <= d;     // normal data capture
end

endmodule