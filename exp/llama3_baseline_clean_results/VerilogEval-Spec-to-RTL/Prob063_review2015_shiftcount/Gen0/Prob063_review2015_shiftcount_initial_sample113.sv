module TopModule (
    input clk,
    input shift_ena,
    input count_ena,
    input data,
    output [3:0] q
);

reg [3:0] r;

always @(posedge clk) begin
    if (shift_ena) begin
        r <= {data, r[3:1]};
    end else if (count_ena) begin
        r <= r - 1;
    end
end

assign q = r;

endmodule