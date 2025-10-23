module TopModule (
    input x,
    input y,
    output z
);
    assign z = ~(x ^ y);  // or equivalently: assign z = x ~^ y;
endmodule