module TopModule(
    output out
);

// Using a parameter for the output value allows for easy modification if needed
parameter OUTPUT_VALUE = 1'b0;
assign out = OUTPUT_VALUE;

endmodule