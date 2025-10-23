module TopModule (
    input x,
    input y,
    output reg z
);
    always @(x or y) begin
        z <= (x == y) ? 1'b1 : 1'b0;
    end
endmodule