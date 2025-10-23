module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

// Using a case statement to explicitly define when out is 1
assign out = 1'b0;
case ({a, b, c})
    3'b000: out = 1'b0;
    3'b001: out = 1'b1;
    3'b010: out = 1'b1;
    3'b011: out = 1'b1;
    3'b100: out = 1'b1;
    3'b101: out = 1'b1;
    3'b110: out = 1'b1;
    3'b111: out = 1'b1;
    default: out = 1'b0;
endcase

endmodule