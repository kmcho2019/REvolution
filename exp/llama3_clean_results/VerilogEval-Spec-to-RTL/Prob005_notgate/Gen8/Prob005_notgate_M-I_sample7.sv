module TopModule(
    input  in,
    output out
);
    // Using a buf instead of assign for potential optimization
    buf out(in);
endmodule