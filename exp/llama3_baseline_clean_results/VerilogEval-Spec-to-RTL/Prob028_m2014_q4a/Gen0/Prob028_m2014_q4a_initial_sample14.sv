module TopModule(
    input  d,
    input  ena,
    output reg q
);

always @(*) begin
    if (ena) begin
        q <= d;
    end else begin
        // No explicit assignment needed here; q retains its value
    end
end

endmodule