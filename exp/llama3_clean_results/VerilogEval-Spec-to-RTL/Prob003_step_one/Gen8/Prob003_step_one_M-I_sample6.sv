// TopModule: Always drives output 'one' high, optimized for minimal area and power.
module TopModule(
    output one
);

// Direct assignment of constant value to output 'one', aiming for minimal synthesis area.
assign one = 1'b1;

endmodule