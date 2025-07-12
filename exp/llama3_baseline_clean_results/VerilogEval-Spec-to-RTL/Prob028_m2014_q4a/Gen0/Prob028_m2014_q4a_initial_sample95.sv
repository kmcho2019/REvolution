module TopModule(
    input  d,
    input  ena,
    output reg q
);

always @(*) begin
    if (ena) begin
        q = d;
    end else begin
        // Do nothing, retain the previous value of q
    end
end

endmodule