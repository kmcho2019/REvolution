module TopModule(
    output one
);
    // Use an always block for combinational logic to assign the value 1 to the output port
    always @(*)
        one = 1'b1;
endmodule