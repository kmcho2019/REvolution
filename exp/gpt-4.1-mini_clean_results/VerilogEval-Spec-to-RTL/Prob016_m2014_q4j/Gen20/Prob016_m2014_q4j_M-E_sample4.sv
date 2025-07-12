module TopModule(
    input  [3:0] x,
    input  [3:0] y,
    output reg [4:0] sum
);
    always @(*) begin
        sum = {1'b0, x} + {1'b0, y}; // zero-extend inputs to 5 bits and add
    end
endmodule