module TopModule(
    input  in,
    output out
);
    // Directly implement the NOT gate using a continuous assignment
    assign out = ~in;
endmodule