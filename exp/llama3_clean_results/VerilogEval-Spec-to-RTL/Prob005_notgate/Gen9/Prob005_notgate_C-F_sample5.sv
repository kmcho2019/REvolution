module TopModule(
    input  in,
    output out
);
    assign out = ~in; // Directly implements the NOT gate functionality
endmodule