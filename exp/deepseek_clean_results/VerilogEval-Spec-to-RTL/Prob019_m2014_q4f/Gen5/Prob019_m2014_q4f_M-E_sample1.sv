module TopModule (
    input in1,
    input in2,
    output out
);
    // Implement AND-NOT using a 2:1 mux
    // out = in2 ? 0 : in1
    assign out = in2 ? 1'b0 : in1;
endmodule