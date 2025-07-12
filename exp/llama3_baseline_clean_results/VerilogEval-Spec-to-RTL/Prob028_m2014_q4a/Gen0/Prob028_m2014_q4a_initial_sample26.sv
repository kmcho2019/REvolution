module TopModule(
    input d,
    input ena,
    output reg q
);

always @(*) begin
    if (ena) begin
        q <= d;
    end else begin
        q <= q; // This is a non-blocking assignment to itself, which means the value of q remains the same
    end
end

endmodule