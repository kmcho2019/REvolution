module TopModule(
    input  wire ring,
    input  wire vibrate_mode,
    output reg  ringer,
    output reg  motor
);

always @(*) begin
    if (ring) begin
        ringer = ~vibrate_mode;
        motor  = vibrate_mode;
    end else begin
        ringer = 1'b0;
        motor  = 1'b0;
    end
end

endmodule