module TopModule(
    input  d,
    input  ena,
    output reg q
);

always @(*) begin
    if (ena) begin
        q = d;
    end else begin
        // Do nothing, hold the previous value
    end
end

endmodule