module TopModule(
    input logic ring,
    input logic vibrate_mode,
    output logic ringer,
    output logic motor
);

always_comb begin
    ringer = ring &&!vibrate_mode;
    motor = ring && vibrate_mode;
end

// Alternatively, factoring out the common 'ring' signal
// always_comb begin
//     if (ring) begin
//         ringer =!vibrate_mode;
//         motor = vibrate_mode;
//     end else begin
//         ringer = 1'b0;
//         motor = 1'b0;
//     end
// end

endmodule