module TopModule (
    input  [15:0] in,
    output [7:0]  out_hi,
    output [7:0]  out_lo
);
// Synthesis attribute to encourage minimal area and low power for the outputs
(* keep = "true", preserve = "true", low_power = "true" *) wire [7:0] out_hi_internal;
(* keep = "true", preserve = "true", low_power = "true" *) wire [7:0] out_lo_internal;

assign out_lo_internal = in[7:0];
assign out_hi_internal = in[15:8];

assign out_lo = out_lo_internal;
assign out_hi = out_hi_internal;

endmodule