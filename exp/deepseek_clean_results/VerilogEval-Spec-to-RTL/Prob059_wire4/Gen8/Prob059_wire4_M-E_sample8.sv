module TopModule (
    input a,
    input b,
    input c,
    output w,
    output x,
    output y,
    output z
);
    // Treat outputs as a 4-bit bus
    wire [3:0] out_bus;
    
    // Mux that always selects direct connection pattern
    assign out_bus = {a, b, b, c};
    
    // Split bus into individual outputs
    assign {w, x, y, z} = out_bus;
endmodule