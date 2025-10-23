module TopModule(
    input x3,
    input x2,
    input x1,
    output logic f
);

always @(*)
begin
    // Case where x2 is 1 and x3 is 0, or where x1 is 1 and x3 is 1
    f = (x2 & ~x3) | (x1 & x3);
end

endmodule