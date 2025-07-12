module TopModule(input in, output out);
    // Behavioral model of a transmission gate
    wire enable = 1'b1;  // Permanently enabled
    assign out = enable ? in : 1'bz;
endmodule