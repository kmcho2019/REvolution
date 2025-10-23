module TopModule (
    output one
);

// Using a parameter to define the output value, in case it needs to be changed in the future
parameter OUTPUT_VALUE = 1'b1;
assign one = OUTPUT_VALUE;

endmodule