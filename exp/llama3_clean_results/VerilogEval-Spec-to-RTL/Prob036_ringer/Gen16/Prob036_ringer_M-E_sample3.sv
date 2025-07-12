module TopModule(
    input ring,
    input vibrate_mode,
    output logic ringer,
    output logic motor
);

// Define states for the finite state machine
enum logic [1:0] {IDLE, RINGING, VIBRATING} state, next_state;

// Initialize the current state
always_ff @(posedge ring or negedge ring) begin
    if (ring) begin
        if (vibrate_mode) begin
            next_state = VIBRATING;
        end else begin
            next_state = RINGING;
        end
    end else begin
        next_state = IDLE;
    end
end

// Update the current state based on the next state
always_ff @(posedge ring or negedge ring) begin
    state = next_state;
end

// Control the outputs based on the current state
always_comb begin
    case (state)
        IDLE: begin
            ringer = 0;
            motor = 0;
        end
        RINGING: begin
            ringer = 1;
            motor = 0;
        end
        VIBRATING: begin
            ringer = 0;
            motor = 1;
        end
        default: begin
            ringer = 0;
            motor = 0;
        end
    endcase
end

endmodule