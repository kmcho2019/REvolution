module TopModule (
    input  [99:0] a,
    input  [99:0] b,
    input         sel,
    output [99:0] out
);

    // Parameters for documentation and flexibility
    localparam BUS_WIDTH = 100;
    
    // Direct bitwise selection - optimal for synthesis
    assign out = sel ? b : a;

endmodule