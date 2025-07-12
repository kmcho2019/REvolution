module TopModule(d, ena, q);
input d, ena;
output reg q;

always @(ena or d) begin
    if (ena) begin
        q <= d;
    end
end
endmodule