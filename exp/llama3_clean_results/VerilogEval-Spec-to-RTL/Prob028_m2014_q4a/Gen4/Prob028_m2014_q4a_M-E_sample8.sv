module TopModule(
    input  d,
    input  ena,
    output reg q
);

reg internal_q;

always @(d, ena, internal_q) begin
    if (~ena) begin
        internal_q = internal_q;
    end else begin
        internal_q = d;
    end
end

assign q = internal_q;

endmodule