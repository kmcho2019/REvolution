module TopModule (
    input in,
    output out
);
    // NOT gate implemented using a 2:1 mux
    assign out = in ? 1'b0 : 1'b1;
endmodule