module TopModule(
    input  in,
    output out
);
    assign out = in; // Direct assignment acts like a buffer, optimal for simplicity and efficiency
endmodule