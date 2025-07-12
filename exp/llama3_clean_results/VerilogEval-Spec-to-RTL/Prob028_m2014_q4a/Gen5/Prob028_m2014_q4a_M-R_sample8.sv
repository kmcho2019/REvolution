module TopModule(
    input  d,
    input  ena,
    output reg q
);
// The always block implements the D latch behavior, 
// assigning 'd' to 'q' when 'ena' is high and retaining 'q' when 'ena' is low.
always @(*) begin
    if (ena) begin
        q <= d;
    end else begin
        q <= q;
    end
end

endmodule