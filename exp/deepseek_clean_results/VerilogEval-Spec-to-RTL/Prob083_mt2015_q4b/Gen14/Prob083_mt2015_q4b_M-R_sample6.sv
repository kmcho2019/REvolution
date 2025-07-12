module TopModule (
    input x,
    input y,
    output z
);
    wire not_x, not_y;
    wire and_xy, and_notx_noty;
    
    assign not_x = ~x;
    assign not_y = ~y;
    assign and_xy = x & y;
    assign and_notx_noty = not_x & not_y;
    assign z = and_xy | and_notx_noty;
endmodule