module TopModule(
    output out
);

// Using a 2-input AND gate with both inputs tied to 0
wire const_zero = 1'b0;
assign out = const_zero & const_zero;

endmodule