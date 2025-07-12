module TopModule(
    input  d,
    input  ena,
    output reg q
);

// Implementing the D latch using an always block as requested
always @(*) begin
    if (ena) begin
        q = d;
    end else begin
        q = q;
    end
end

endmodule