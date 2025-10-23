module TopModule(
    input ring,
    input vibrate_mode,
    output logic ringer,
    output logic motor
);

enum logic [1:0] {IDLE, RINGER, VIBRATE} state;

always_comb begin
    case (state)
        IDLE: begin
            if (ring) begin
                if (vibrate_mode) begin
                    state = VIBRATE;
                end else begin
                    state = RINGER;
                end
            end
        end
        RINGER: begin
            ringer = 1'b1;
            motor = 1'b0;
            if (~ring) begin
                state = IDLE;
            end
        end
        VIBRATE: begin
            ringer = 1'b0;
            motor = 1'b1;
            if (~ring) begin
                state = IDLE;
            end
        end
        default: state = IDLE;
    endcase
end

always_comb begin
    if (state == RINGER) begin
        ringer = 1'b1;
        motor = 1'b0;
    end else if (state == VIBRATE) begin
        ringer = 1'b0;
        motor = 1'b1;
    end else begin
        ringer = 1'b0;
        motor = 1'b0;
    end
end

endmodule