module TopModule(
    input  wire        clk,
    input  wire        ring,
    input  wire        vibrate_mode,
    output reg         ringer,
    output reg         motor
);

wire ringer_next = ring & ~vibrate_mode;
wire motor_next  = ring &  vibrate_mode;

always @(posedge clk) begin
    ringer <= ringer_next;
    motor  <= motor_next;
end

endmodule