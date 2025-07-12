module TopModule (
    input x,
    input y,
    output z
);
    // Alternative implementation that might map better to some libraries
    wire x_and_y, notx_and_noty;
    
    assign x_and_y = x & y;
    assign notx_and_noty = ~x & ~y;
    assign z = x_and_y | notx_and_noty;
endmodule