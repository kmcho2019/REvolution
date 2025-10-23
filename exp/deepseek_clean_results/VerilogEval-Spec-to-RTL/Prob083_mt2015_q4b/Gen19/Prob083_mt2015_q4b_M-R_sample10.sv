module TopModule (
    input x,
    input y,
    output reg z
);
    always @(x or y) begin
        z = ~(x ^ y);  // XNOR operation in procedural block
    end
endmodule