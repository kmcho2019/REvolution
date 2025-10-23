module TopModule (
    input clk,
    input ar,
    input d,
    output reg q
);

always @(posedge ar) begin
    q <= 1'b0;
end

always @(posedge clk) begin
    q <= d;
end

endmodule