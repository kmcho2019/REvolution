module TopModule(
    input  wire ring,
    input  wire vibrate_mode,
    output reg  ringer,
    output reg  motor
);

always @(*) begin
    // Default values
    ringer = 1'b0;
    motor  = 1'b0;
    
    if (ring) begin
        if (vibrate_mode)
            motor = 1'b1;
        else
            ringer = 1'b1;
    end
end

endmodule