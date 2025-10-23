module TopModule(
    input logic ring,
    input logic vibrate_mode,
    output logic ringer,
    output logic motor
);

always_comb begin
    if (ring) begin
        ringer = ~vibrate_mode;
        motor = vibrate_mode;
    end else begin
        ringer = 0;
        motor = 0;
    end
end

endmodule