module TopModule(
    input  wire ring,
    input  wire vibrate_mode,
    output wire ringer,
    output wire motor
);

wire [1:0] output_sel;

// Use ring as enable and vibrate_mode as selector for mutually exclusive outputs
// output_sel[1] -> motor
// output_sel[0] -> ringer
assign output_sel = ring ? (vibrate_mode ? 2'b10 : 2'b01) : 2'b00;

assign ringer = output_sel[0];
assign motor  = output_sel[1];

endmodule