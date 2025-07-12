module TopModule (
    output zero
);
    // Equivalent to ANDing with 0 or NORing with 1, but implemented as direct assignment
    assign zero = 1'b0;
endmodule