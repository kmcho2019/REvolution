module TopModule (
    input x,
    input y,
    output reg z
);
    always @(x or y) begin
        // Explicit XNOR operation - outputs 1 when inputs are equal
        z = (x == y) ? 1'b1 : 1'b0;
    end
endmodule