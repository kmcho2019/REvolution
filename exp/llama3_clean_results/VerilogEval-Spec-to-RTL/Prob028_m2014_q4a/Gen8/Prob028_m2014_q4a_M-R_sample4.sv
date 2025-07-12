module TopModule(
    input  d,
    input  ena,
    output reg q
);

reg prev_q;

always @(ena or d) begin
    if (ena) begin
        prev_q <= d;
    end else begin
        prev_q <= prev_q;
    end
end

assign q = prev_q;

endmodule