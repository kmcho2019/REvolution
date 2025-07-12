module TopModule (
    output out
);
    wire w = 1'b1;  // Could be any value, doesn't matter
    assign out = w & ~w & ~w & ~w;
endmodule