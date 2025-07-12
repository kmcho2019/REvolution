module TopModule(
    input  in,
    output out
);
    // The NOT gate is implemented using a simple and efficient assignment.
    // This approach is optimal for area and power efficiency, as it involves minimal logic.
    assign out = ~in;
endmodule