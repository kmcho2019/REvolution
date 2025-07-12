module TopModule(
    input ring,
    input vibrate_mode,
    output ringer,
    output motor
);

always @(*) begin
    case ({ring, vibrate_mode})
        2'b00: begin
            ringer = 0;
            motor = 0;
        end
        2'b01: begin
            ringer = 0;
            motor = 1;
        end
        2'b10: begin
            ringer = 1;
            motor = 0;
        end
        2'b11: begin
            ringer = 0;
            motor = 1;
        end
    endcase
end

endmodule