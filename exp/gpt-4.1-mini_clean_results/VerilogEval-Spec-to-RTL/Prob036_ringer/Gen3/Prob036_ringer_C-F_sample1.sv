module TopModule(
    input  wire ring,
    input  wire vibrate_mode,
    output reg  ringer,
    output reg  motor
);

always @(*) begin
    ringer = ring ? ~vibrate_mode : 1'b0;
    motor  = ring ?  vibrate_mode : 1'b0;
end

endmodule