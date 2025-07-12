module TopModule (
    input in1,
    input in2,
    output out
);
    // Implement in1 AND NOT in2 using a 2:1 mux
    assign out = in2 ? 1'b0 : in1;
endmodule