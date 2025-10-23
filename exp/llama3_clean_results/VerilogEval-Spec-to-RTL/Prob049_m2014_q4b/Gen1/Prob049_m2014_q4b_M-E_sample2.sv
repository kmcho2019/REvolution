module TopModule(
    input clk,
    input ar,
    input d,
    output reg q
);

always @(posedge ar) begin
    q <= 0;
end

always @(posedge clk or posedge ar) begin
    if (!ar) begin
        q <= d;
    end else begin
        q <= 0;
    end
end

endmodule