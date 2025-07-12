module TopModule(
    input  d,
    input  ena,
    output reg q = 1'b0 // Default initialization to avoid X values
);

always @(*) begin
    if (ena) begin
        q <= d;
    end
end

endmodule