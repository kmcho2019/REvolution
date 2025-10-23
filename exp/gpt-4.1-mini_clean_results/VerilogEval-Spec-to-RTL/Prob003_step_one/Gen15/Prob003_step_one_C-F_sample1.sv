module TopModule(output wire one);
    // Output is permanently driven high; inferred as a constant '1'
    assign one = 1'b1;
endmodule