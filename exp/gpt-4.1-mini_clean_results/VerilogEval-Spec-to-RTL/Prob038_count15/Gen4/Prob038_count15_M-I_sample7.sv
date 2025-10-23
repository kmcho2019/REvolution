module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

reg count_en;

// Generate a count enable signal that toggles every 2 clock cycles
always @(posedge clk) begin
    if (reset)
        count_en <= 1'b0;
    else
        count_en <= ~count_en;
end

always @(posedge clk) begin
    if (reset)
        q <= 4'b0000;
    else if (count_en)
        q <= q + 1;
end

endmodule