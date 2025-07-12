module TopModule(
    input  wire ring,
    input  wire vibrate_mode,
    output reg  ringer,
    output reg  motor
);

always @(*) begin
    if (ring) begin
        {ringer, motor} = vibrate_mode ? 2'b01 : 2'b10;
    end else begin
        {ringer, motor} = 2'b00;
    end
end

endmodule