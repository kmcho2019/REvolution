module TopModule (
    input in,
    output out
);
    // Direct combinational connection - optimal PPA
    assign out = in;
endmodule