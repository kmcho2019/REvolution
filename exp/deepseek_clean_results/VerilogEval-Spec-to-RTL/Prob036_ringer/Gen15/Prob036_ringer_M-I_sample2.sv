module TopModule (
    input ring,
    input vibrate_mode,
    output ringer,
    output motor
);

assign motor  = vibrate_mode ? ring : 1'b0;
assign ringer = ~vibrate_mode ? ring : 1'b0;

endmodule