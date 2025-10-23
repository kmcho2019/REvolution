module TopModule (
    input  wire a,    // Input bit a
    input  wire b,    // Input bit b
    input  wire sel,  // Select signal
    output reg  out   // Output bit (reg type for procedural assignment)
);

always @(*) begin
    if (sel)
        out = b;
    else
        out = a;
end

endmodule