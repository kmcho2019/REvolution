module TopModule (
    input [3:0] a,
    input [3:0] b,
    input [3:0] c,
    input [3:0] d,
    input [3:0] e,
    output [3:0] q
);

// LUT for output selection encoding:
// 00: b (0)
// 01: e (1)
// 10: a (2)
// 11: d (3)
wire [1:0] output_sel;
assign output_sel = c[1:0];

// Priority encoder for output selection
wire [3:0] selected_output;
assign selected_output = (output_sel == 2'b00) ? b :
                        (output_sel == 2'b01) ? e :
                        (output_sel == 2'b10) ? a :
                        d;

// Final output selection with default case
assign q = (c > 4'd3) ? 4'b1111 : selected_output;

endmodule