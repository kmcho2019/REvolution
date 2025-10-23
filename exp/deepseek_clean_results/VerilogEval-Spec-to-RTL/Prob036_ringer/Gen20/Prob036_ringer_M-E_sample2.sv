module TopModule (
    input ring,
    input vibrate_mode,
    output ringer,
    output motor
);

    // Internal state encoding:
    // [1]: motor active
    // [0]: ringer active
    wire [1:0] output_state;
    
    // Priority encoding:
    // 1. When not ringing, both outputs are off (00)
    // 2. When ringing in vibrate mode, motor on (10)
    // 3. When ringing normally, ringer on (01)
    assign output_state = {ring & vibrate_mode, ring & ~vibrate_mode};
    
    // Output assignments
    assign motor = output_state[1];
    assign ringer = output_state[0];

endmodule