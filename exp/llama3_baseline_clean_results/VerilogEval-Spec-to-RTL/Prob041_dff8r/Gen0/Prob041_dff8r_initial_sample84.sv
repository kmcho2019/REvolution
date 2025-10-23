module TopModule(
    input           clk,
    input           reset,
    input   [7:0]   d,
    output  [7:0]   q
);

always_ff @(posedge clk) begin
    if (reset) begin
        q <= 8'b0; // synchronous reset
    end else begin
        q <= d; // load data on positive edge of clk
    end
end

endmodule