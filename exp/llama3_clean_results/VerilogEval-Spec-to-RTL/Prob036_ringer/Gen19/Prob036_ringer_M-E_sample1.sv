module TopModule(
    input logic ring,
    input logic vibrate_mode,
    output logic ringer,
    output logic motor
);

enum logic [1:0] {IDLE, RINGING} state, next_state;

always_comb begin
    case (state)
        IDLE: begin
            if (ring) begin
                next_state = RINGING;
            end else begin
                next_state = IDLE;
            end
        end
        RINGING: begin
            if (~ring) begin
                next_state = IDLE;
            end else begin
                next_state = RINGING;
            end
        end
    endcase
end

always_comb begin
    case (state)
        IDLE: begin
            ringer = 0;
            motor = 0;
        end
        RINGING: begin
            if (vibrate_mode) begin
                ringer = 0;
                motor = 1;
            end else begin
                ringer = 1;
                motor = 0;
            end
        end
    endcase
end

always_ff @(posedge ring or negedge ring) begin
    state <= next_state;
end

initial begin
    state = IDLE;
end

endmodule