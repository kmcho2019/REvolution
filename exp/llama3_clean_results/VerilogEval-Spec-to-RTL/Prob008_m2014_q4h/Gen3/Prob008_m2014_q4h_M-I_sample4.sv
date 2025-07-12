module TopModule(
    input  in,
    output out
);

// Using a low-power buffer gate to reduce power consumption
buf (out, in);

endmodule