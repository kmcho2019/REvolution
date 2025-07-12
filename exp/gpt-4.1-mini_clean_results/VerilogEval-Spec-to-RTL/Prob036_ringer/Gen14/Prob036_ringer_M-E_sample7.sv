module TopModule(
    input  wire ring,
    input  wire vibrate_mode,
    output wire ringer,
    output wire motor
);

reg [1:0] state; // state[0] = ringer, state[1] = motor

always @(*) begin
    if (ring) begin
        if (vibrate_mode)
            state = 2'b10;  // motor on
        else
            state = 2'b01;  // ringer on
    end else begin
        state = 2'b00;      // both off
    end
end

assign ringer = state[0];
assign motor  = state[1];

endmodule