module TopModule(
    input ring,
    input vibrate_mode,
    output ringer,
    output motor
);

wire selected_output;

// Use vibrate_mode as select between ringer=1 or motor=1 (encoded in selected_output)
assign selected_output = ring & ~vibrate_mode;

assign ringer = selected_output;
assign motor  = ring & vibrate_mode;

endmodule