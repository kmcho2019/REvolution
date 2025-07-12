module TopModule(input d, ena, output reg q);
always @(d or ena) begin
    if (ena)
        q <= d;
end
endmodule