module TopModule (
    input x,
    input y,
    output z
);
    wire y_bar;
    
    // Inverter for y (only needed when x is high)
    assign y_bar = ~y;
    
    // Transmission gate style implementation
    assign z = x ? y_bar : 1'b0;
endmodule