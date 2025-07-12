module TopModule (
    input  wire x,
    input  wire y,
    output reg  z
);
    always @(*) begin
        z = x & ~y;
    end
endmodule