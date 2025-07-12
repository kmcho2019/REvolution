module TopModule (
    output zero
);
    // Using an AND gate where one input is permanently 0
    // This will always output 0 regardless of the other input
    and(zero, 1'b0, 1'b1);
endmodule