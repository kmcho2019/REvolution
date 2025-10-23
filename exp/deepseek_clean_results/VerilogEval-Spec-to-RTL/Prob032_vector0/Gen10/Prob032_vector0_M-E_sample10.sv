module TopModule (
    input [2:0] vec,
    output [2:0] outv,
    output o2,
    output o1,
    output o0
);

    // Internal wires for explicit bit extraction
    wire bit0, bit1, bit2;
    
    // Bit extraction using shift and mask (alternative approach)
    assign bit0 = vec & 3'b001;
    assign bit1 = (vec >> 1) & 1'b1;
    assign bit2 = (vec >> 2) & 1'b1;
    
    // Vector output assignment
    assign outv = {bit2, bit1, bit0};
    
    // Individual bit outputs
    assign o0 = bit0;
    assign o1 = bit1;
    assign o2 = bit2;

endmodule