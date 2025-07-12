module TopModule (
    output one
);
    wire constant_one = 1'b1;
    assign one = constant_one;
endmodule