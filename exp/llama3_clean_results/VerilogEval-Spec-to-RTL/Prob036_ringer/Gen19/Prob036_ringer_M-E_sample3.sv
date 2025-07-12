module TopModule(
    input ring,
    input vibrate_mode,
    output logic ringer,
    output logic motor
);

enum logic [1:0] {Idle, Ringing} state, next_state;

always_comb begin
    case (state)
        Idle: begin
            if (ring) begin
                next_state = Ringing;
            end else begin
                next_state = Idle;
            end
        end
        Ringing: begin
            if (~ring) begin
                next_state = Idle;
            end else begin
                next_state = Ringing;
            end
        end
        default: next_state = Idle;
    endcase
end

always_ff @(posedge ring or negedge ring) begin
    state <= next_state;
    case (state)
        Idle: begin
            ringer <= 0;
            motor <= 0;
        end
        Ringing: begin
            if (vibrate_mode) begin
                ringer <= 0;
                motor <= 1;
            end else begin
                ringer <= 1;
                motor <= 0;
            end
        end
        default: begin
            ringer <= 0;
            motor <= 0;
        end
    endcase
end

initial begin
    state = Idle;
    ringer = 0;
    motor = 0;
end

endmodule