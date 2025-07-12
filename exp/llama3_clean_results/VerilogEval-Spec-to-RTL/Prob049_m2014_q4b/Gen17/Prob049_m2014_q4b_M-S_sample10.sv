module TopModule(
    input clk,
    input ar,
    input d,
    output reg q
);

always @(posedge ar or posedge clk) begin
    if (ar) begin
        q <= 1'b0;
    end else begin
        q <= d;
    end
end

endmodule