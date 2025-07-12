module TopModule (
    input in,
    output out
);
    // Implement NOT using a 2:1 mux
    // When in=0, select 1 (out=1)
    // When in=1, select 0 (out=0)
    assign out = in ? 1'b0 : 1'b1;
endmodule