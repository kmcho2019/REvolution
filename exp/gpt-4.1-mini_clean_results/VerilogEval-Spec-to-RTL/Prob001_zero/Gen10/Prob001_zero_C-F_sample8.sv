module TopModule(output zero);
    // Output zero is tied directly to constant logic 0 for optimal power and area.
    assign zero = 1'b0;
endmodule