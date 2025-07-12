module TopModule(
    input ring,
    input vibrate_mode,
    output logic ringer,
    output logic motor
);

always_comb begin
    if (ring) begin
        case (vibrate_mode)
            1'b0: begin
                ringer = 1'b1;
                motor = 1'b0;
            end
            1'b1: begin
                ringer = 1'b0;
                motor = 1'b1;
            end
            default: begin
                ringer = 1'b0;
                motor = 1'b0;
            end
        endcase
    end else begin
        ringer = 1'b0;
        motor = 1'b0;
    end
end

endmodule