module TopModule(
    output one
);
// Using a parameter for the output value could make the code more flexible
parameter OUTPUT_VALUE = 1'b1;
assign one = OUTPUT_VALUE;
endmodule