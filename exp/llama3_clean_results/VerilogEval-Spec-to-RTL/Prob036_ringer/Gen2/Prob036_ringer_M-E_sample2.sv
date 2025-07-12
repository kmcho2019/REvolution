module TopModule(
    input  ring,
    input  vibrate_mode,
    output ringer,
    output motor
);

reg [1:0] state;
reg [1:0] next_state;

always @(*) begin
    case(state)
        2'b00: begin // IDLE state
            if (ring) begin
                next_state = 2'b01; // Transition to RINGING state
            end else begin
                next_state = 2'b00; // Stay in IDLE state
            end
        end
        2'b01: begin // RINGING state
            if (!ring) begin
                next_state = 2'b00; // Transition back to IDLE state
            end else begin
                next_state = 2'b01; // Stay in RINGING state
            end
        end
        default: begin
            next_state = 2'b00; // Default to IDLE state
        end
    endcase
end

always @(*) begin
    case(state)
        2'b00: begin // IDLE state
            ringer = 0;
            motor = 0;
        end
        2'b01: begin // RINGING state
            if (vibrate_mode) begin
                ringer = 0;
                motor = 1;
            end else begin
                ringer = 1;
                motor = 0;
            end
        end
        default: begin
            ringer = 0;
            motor = 0;
        end
    endcase
end

always @(posedge ring or negedge ring) begin
    state <= next_state;
end

initial begin
    state = 2'b00; // Initialize to IDLE state
end

endmodule