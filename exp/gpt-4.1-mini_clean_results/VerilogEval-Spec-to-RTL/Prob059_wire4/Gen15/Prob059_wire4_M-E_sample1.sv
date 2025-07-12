module TopModule (
    input  wire a,
    input  wire b,
    input  wire c,
    output reg  w,
    output reg  x,
    output reg  y,
    output reg  z
);

    // Combinational always block sensitive to inputs
    always @(*) begin
        // Register-like buffering of inputs to outputs
        w = a;
        x = b;
        y = b;
        z = c;
    end

endmodule