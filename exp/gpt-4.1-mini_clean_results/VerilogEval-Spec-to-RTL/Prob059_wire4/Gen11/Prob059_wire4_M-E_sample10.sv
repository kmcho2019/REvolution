module TopModule (
    input  wire a,
    input  wire b,
    input  wire c,
    output reg  w,
    output reg  x,
    output reg  y,
    output reg  z
);

    // Combinational logic block grouping all output assignments
    always @(*) begin
        w = a;
        x = b;
        y = b;
        z = c;
    end

endmodule