module TopModule (
    input a,
    input b,
    output out
);
    assign out = a ^~ b; // Using Verilog's XNOR operator for clarity
endmodule