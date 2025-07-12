module TopModule (
    input  in,
    output out
);

wire sel = 1'b0; // constant select signal, always selects input 'in'

assign out = (sel == 1'b0) ? in : 1'b0;

endmodule