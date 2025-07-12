module TopModule(
    input  d,
    input  ena,
    output reg q = 1'b0
);

always @(*) begin
    if (ena) q = d; // Using blocking assignment for direct assignment
    else q = q; // Retaining previous value when ena is low
end

endmodule