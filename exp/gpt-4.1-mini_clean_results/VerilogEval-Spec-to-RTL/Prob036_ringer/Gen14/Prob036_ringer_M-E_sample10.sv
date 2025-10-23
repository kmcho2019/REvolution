module TopModule(
    input  wire ring,
    input  wire vibrate_mode,
    output wire ringer,
    output wire motor
);

    wire [1:0] output_vector;

    // Define the output vector to represent [motor, ringer]
    // If vibrate_mode=0 => ringer active (bit 0 = 1)
    // If vibrate_mode=1 => motor active (bit 1 = 1)
    assign output_vector = ring ? (vibrate_mode ? 2'b10 : 2'b01) : 2'b00;

    assign motor  = output_vector[1];
    assign ringer = output_vector[0];

endmodule