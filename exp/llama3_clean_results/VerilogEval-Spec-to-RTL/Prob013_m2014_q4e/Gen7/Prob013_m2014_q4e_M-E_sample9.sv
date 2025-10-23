module TopModule(
    input  in1,
    input  in2,
    output out
);

// Generate the control signal based on the inputs
wire control = ~(in1 | in2);

// Use a multiplexer to select between the inputs and their inverted versions
assign out = (control)? 1'b1 : (in1 & in2);

endmodule