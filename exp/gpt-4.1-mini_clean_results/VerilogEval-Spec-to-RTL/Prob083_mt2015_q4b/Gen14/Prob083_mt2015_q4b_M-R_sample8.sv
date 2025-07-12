module TopModule(
    input  wire x,
    input  wire y,
    output reg  z
);
    // Procedural combinational logic block
    always @(*) begin
        if (x == y)
            z = 1'b1;  // z is high when x equals y
        else
            z = 1'b0;  // z is low otherwise
    end
endmodule