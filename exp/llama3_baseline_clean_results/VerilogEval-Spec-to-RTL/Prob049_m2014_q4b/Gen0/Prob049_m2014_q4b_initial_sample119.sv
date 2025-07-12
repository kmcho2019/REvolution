module TopModule(
    input clk,
    input ar,
    input d,
    output q
    );

reg internal_q;

always @(posedge clk or posedge ar) begin
    if (ar) begin
        internal_q <= 1'b0;
    end else begin
        internal_q <= d;
    end
end

assign q = internal_q;

endmodule