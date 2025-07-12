module TopModule (
    input [3:0] a,
    input [3:0] b,
    input [3:0] c,
    input [3:0] d,
    input [3:0] e,
    output reg [3:0] q
);

localparam SEL_B = 4'b0000;
localparam SEL_E = 4'b0001;
localparam SEL_A = 4'b0010;
localparam SEL_D = 4'b0011;

always @(*) begin
    // Priority encoder style selection
    if (c == SEL_B)        q = b;
    else if (c == SEL_E)   q = e;
    else if (c == SEL_A)   q = a;
    else if (c == SEL_D)   q = d;
    else                   q = 4'bxxxx; // Don't care for power optimization
end

endmodule