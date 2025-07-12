module TopModule(
    input ring,
    input vibrate_mode,
    output ringer,
    output motor
);

    // Encoded state: 2'b00 = off, 2'b01 = ringer, 2'b10 = motor
    wire [1:0] mode_state;

    assign mode_state = ring ? (vibrate_mode ? 2'b10 : 2'b01) : 2'b00;

    // Decode state to outputs
    assign ringer = (mode_state == 2'b01);
    assign motor  = (mode_state == 2'b10);

endmodule