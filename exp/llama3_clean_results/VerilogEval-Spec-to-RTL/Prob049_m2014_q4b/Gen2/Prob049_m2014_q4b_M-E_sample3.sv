module TopModule (
    input  clk,
    input  ar,
    input  d,
    output reg q
);

reg temp_q;

always @(posedge ar) begin
    temp_q <= 1'b0;
end

always @(posedge clk) begin
    if (!ar) begin
        temp_q <= d;
    end
    q <= temp_q;
end

endmodule