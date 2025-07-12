module TopModule(
    input clk,
    input ar,
    input d,
    output reg q
);

reg mid_q;

always @(posedge ar or negedge clk) begin
    if (ar) begin
        mid_q <= 1'b0;
    end else begin
        mid_q <= d;
    end
end

always @(posedge ar or posedge clk) begin
    if (ar) begin
        q <= 1'b0;
    end else begin
        q <= mid_q;
    end
end

endmodule