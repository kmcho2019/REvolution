module TopModule(
    input  d,
    input  ena,
    output reg q
);

always @(*) begin
    if (ena) begin
        q = d;
    end else begin
        // No action needed here, as q should retain its value when ena is low
    end
end

endmodule