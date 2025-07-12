module TopModule(
    input  clk,
    input  d,
    input  r,
    output q
);

reg q_int;
assign q = q_int;

always @(posedge clk) begin
    if (r) begin
        q_int <= 1'b0;
    end else begin
        q_int <= d;
    end
end

endmodule