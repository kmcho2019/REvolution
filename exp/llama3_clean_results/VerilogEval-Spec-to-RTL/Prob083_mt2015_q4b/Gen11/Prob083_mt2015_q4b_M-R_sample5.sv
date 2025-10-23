module TopModule(
    input x,
    input y,
    output logic z
);
    // Using a conditional operator to assign z
    assign z = (x == y) ? 1'b1 : 1'b0;
endmodule