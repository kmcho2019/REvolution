module TopModule(input d, ena, output reg q);
always @(*) begin
    if (ena) q = d;
end
endmodule