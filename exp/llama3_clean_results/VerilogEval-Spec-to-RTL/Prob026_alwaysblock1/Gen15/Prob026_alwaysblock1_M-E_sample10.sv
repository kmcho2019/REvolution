// Parameterizable module for LUT-based AND gate implementation
module AndLUT #(
    parameter WIDTH = 1
)(
    input  [WIDTH-1:0] a,
    input  [WIDTH-1:0] b,
    output [WIDTH-1:0] out_assign,
    output [WIDTH-1:0] out_alwaysblock
);

// Define the LUT for AND operation
reg [WIDTH-1:0] lut_out;

// Combinational always block to update lut_out based on inputs
always @(*) begin
    lut_out = a & b;
end

// Assign statement to drive out_assign
assign out_assign = lut_out;

// Drive out_alwaysblock directly from lut_out
always @(*) begin
    out_alwaysblock = lut_out;
end

endmodule

// TopModule that instantiates the LUT-based implementation
module TopModule(
    input  a,
    input  b,
    output out_assign,
    output out_alwaysblock
);
    
AndLUT #(.WIDTH(1)) u_and_lut(
    .a(a),
    .b(b),
    .out_assign(out_assign),
    .out_alwaysblock(out_alwaysblock)
);

endmodule