module TopModule(
    input logic ring,
    input logic vibrate_mode,
    output logic ringer,
    output logic motor
);

always_comb begin
    case (ring)
        1'b1: begin
            if (vibrate_mode) begin
                ringer = 1'b0;
                motor = 1'b1;
            end else begin
                ringer = 1'b1;
                motor = 1'b0;
            end
        end
        1'b0: begin
            ringer = 1'b0;
            motor = 1'b0;
        end
        default: begin
            ringer = 1'b0;
            motor = 1'b0;
        end
    endcase
end

endmodule