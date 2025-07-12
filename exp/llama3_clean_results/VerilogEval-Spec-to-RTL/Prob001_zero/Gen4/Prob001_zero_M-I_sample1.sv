module TopModule(
    output zero
);
    // Directly assign a constant LOW value to the output port 'zero'
    // Using a synthesis attribute to specify the output port is a constant
    (* constant = "true" *) assign zero = 1'b0;
endmodule