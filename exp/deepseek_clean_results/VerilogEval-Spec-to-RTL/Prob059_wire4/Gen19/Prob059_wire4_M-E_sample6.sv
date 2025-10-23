module TopModule (
    input  a,
    input  b,
    input  c,
    output w,
    output x,
    output y,
    output z
);
    // Define bus widths (parameterized for potential expansion)
    localparam IN_WIDTH = 3;
    localparam OUT_WIDTH = 4;
    
    // Create input and output buses
    wire [IN_WIDTH-1:0]  in_bus  = {c, b, a};  // Note reverse order for easier indexing
    wire [OUT_WIDTH-1:0] out_bus;
    
    // Structured routing matrix
    assign out_bus[0] = in_bus[2];  // a -> w
    assign out_bus[1] = in_bus[1];  // b -> x
    assign out_bus[2] = in_bus[1];  // b -> y
    assign out_bus[3] = in_bus[0];  // c -> z
    
    // Map output bus to individual outputs
    assign {z, y, x, w} = out_bus;  // Note reverse order to match original output positions
endmodule