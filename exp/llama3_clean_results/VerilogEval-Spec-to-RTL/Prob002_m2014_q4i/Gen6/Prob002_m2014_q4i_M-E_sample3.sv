// Novel solution using a combinational logic circuit
module TopModule(
    output out
);
    // Create a constant input for the inverter
    wire const_input;
    assign const_input = 1'b1;
    
    // Use an inverter to generate the constant output
    assign out = ~const_input;
endmodule