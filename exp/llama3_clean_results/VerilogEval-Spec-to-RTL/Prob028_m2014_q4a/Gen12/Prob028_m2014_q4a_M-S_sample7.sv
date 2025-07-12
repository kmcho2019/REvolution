module TopModule(
    input  d,
    input  ena,
    output reg q
);

// Use an always block sensitive to d and ena for a simple D latch implementation
always @(*) begin
    if (ena) begin
        q = d;
    end
end

endmodule