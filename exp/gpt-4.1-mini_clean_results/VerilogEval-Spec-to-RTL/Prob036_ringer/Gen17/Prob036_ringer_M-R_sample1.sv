module TopModule(
    input  wire ring,           // Incoming call indicator
    input  wire vibrate_mode,   // Vibrate mode selector
    output reg  ringer,         // Ringer output (sound)
    output reg  motor           // Vibration motor output
);

always @(*) begin
    if (ring) begin
        if (vibrate_mode) begin
            motor  = 1'b1;
            ringer = 1'b0;
        end else begin
            motor  = 1'b0;
            ringer = 1'b1;
        end
    end else begin
        motor  = 1'b0;
        ringer = 1'b0;
    end
end

endmodule