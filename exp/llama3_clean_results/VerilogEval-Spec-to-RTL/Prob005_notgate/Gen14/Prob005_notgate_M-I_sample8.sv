module TopModule(
    input  in,
    output out
);
    // The NOT gate is implemented using a simple assignment.
    // This approach is both area and power-efficient, as it involves minimal logic.
    assign out = ~in;
endmodule