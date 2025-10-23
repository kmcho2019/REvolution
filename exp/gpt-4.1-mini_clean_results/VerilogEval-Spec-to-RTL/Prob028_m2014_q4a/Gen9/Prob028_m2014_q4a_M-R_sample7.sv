module TopModule(
    input d,
    input ena,
    output reg q
);

always @(*) begin
    if (ena)
        q = d;   // transparent mode: q follows d
    else
        q = q;   // latch holds value by retaining previous q
end

endmodule