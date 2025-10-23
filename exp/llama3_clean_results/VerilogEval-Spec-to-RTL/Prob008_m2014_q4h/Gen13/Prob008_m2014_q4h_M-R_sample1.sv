module TopModule(
    input  in,
    output out
);
    assign out = ~(~in);  // Using double negation to demonstrate a different structure
endmodule