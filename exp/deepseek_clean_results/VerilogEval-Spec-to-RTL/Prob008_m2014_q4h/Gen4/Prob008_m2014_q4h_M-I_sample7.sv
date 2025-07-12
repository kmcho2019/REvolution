module TopModule (
    input in,
    output out,
    input en // Optional enable (default to 1'b1 if not connected)
);
    assign out = en ? in : 1'b0;
endmodule