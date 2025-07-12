module TopModule (
    input  wire x,
    input  wire y,
    output wire z
);

wire y_not;
assign y_not = ~y;

// MUX implementation: if x=0 select y_not else y
assign z = x ? y : y_not;

endmodule