module TopModule (
    input clk,
    input ar,
    input d,
    output reg q
);

reg temp_q;

always @(posedge clk) begin
    temp_q <= d;
end

always @(*) begin
    if (ar) begin
        q <= 1'b0;
    end else begin
        q <= temp_q;
    end
end

endmodule