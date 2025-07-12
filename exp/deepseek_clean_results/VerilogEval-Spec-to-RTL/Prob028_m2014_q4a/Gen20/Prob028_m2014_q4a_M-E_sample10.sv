module TopModule(input d, ena, output reg q);
always @(ena or d) begin
    if (ena) q <= d;
end
endmodule