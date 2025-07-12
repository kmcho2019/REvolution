module TopModule(
    input  a,
    input  b,
    output out
);

// Using combinational logic to reduce power consumption
assign out = ~(a ^ b);

endmodule