module TopModule(
    input in1,
    input in2,
    output out
);

    // Use a 2-to-1 multiplexer to select between 'in1' and '0' based on 'in2'
    assign out = in2 ? 1'b0 : in1;

endmodule