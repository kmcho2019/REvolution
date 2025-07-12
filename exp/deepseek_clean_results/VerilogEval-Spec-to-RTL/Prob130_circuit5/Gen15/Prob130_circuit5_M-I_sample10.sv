module TopModule (
    input [3:0] a,
    input [3:0] b,
    input [3:0] c,
    input [3:0] d,
    input [3:0] e,
    output [3:0] q
);

// Detect valid selection cases (c < 4)
wire valid_selection = ~(|c[3:2]);

// Direct 4:1 multiplexer implementation
assign q = valid_selection ? 
              (c[1:0] == 2'b00) ? b :
              (c[1:0] == 2'b01) ? e :
              (c[1:0] == 2'b10) ? a : d
            : 4'b1111;

endmodule