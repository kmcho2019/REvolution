module TopModule (
    input x,
    input y,
    output reg z
);
    always @(x or y) begin
        z = x & ~y;
    end
endmodule