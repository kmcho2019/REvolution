module TopModule(
    input  d,
    input  ena,
    output reg q
);

always @(*) begin
    if (ena) begin
        q <= d;
    end else begin
        q <= q; // To keep the value of q when ena is 0
    end
end

endmodule