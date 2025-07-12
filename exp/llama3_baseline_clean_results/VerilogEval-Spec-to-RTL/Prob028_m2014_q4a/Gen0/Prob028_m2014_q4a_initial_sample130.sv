module TopModule(
    input  d,
    input  ena,
    output reg q
);

always @(*) begin
    if (ena) begin
        q <= d;
    end else begin
        // No need to explicitly assign q, it will retain its previous value
    end
end

endmodule