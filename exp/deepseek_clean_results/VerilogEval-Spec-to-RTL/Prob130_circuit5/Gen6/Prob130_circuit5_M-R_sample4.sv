module TopModule (
    input [3:0] a,
    input [3:0] b,
    input [3:0] c,
    input [3:0] d,
    input [3:0] e,
    output [3:0] q
);

// Determine if selection is valid (c < 4)
wire valid_sel = ~|c[3:2];  // NOR of upper 2 bits

// Expanded mux that includes the 'f' case
assign q = (valid_sel) ? 
           (c[1:0] == 2'b00 ? b :
            c[1:0] == 2'b01 ? e :
            c[1:0] == 2'b10 ? a :
            d) : 4'hf;

endmodule