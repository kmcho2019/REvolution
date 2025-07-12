module TopModule (
    input  wire x,
    input  wire y,
    output reg  z
);

always @(*) begin
    // z is 1 if both inputs are equal, 0 otherwise
    if (x == y)
        z = 1'b1;
    else
        z = 1'b0;
end

endmodule