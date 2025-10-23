module TopModule(
    input clk,
    input ar,
    input d,
    output reg q
);

reg mid_q;

always @(posedge clk or posedge ar) begin
    if (ar) begin
        mid_q <= 1'b0;
        q <= 1'b0;
    end else begin
        mid_q <= d;
    end
end

always @(negedge clk or posedge ar) begin
    if (ar) begin
        q <= 1'b0;
    end else begin
        q <= mid_q;
    end
end

endmodule