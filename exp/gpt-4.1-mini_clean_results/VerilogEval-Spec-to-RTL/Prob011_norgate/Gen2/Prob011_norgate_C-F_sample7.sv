module TopModule (
    input  a,
    input  b,
    output out
);

// Intermediate signal for OR of inputs
wire or_result;

// OR inputs first
assign or_result = a | b;

// NOR output: high only when both inputs are low
assign out = ~or_result;

endmodule