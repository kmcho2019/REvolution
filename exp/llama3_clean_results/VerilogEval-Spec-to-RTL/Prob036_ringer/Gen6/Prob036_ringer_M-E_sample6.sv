// Module TopModule: controls a cellphone's ringer and vibration motor
module TopModule(
    input ring,  // input signal indicating an incoming call
    input vibrate_mode,  // input signal indicating vibrate mode
    output ringer,  // output signal controlling the ringer
    output motor  // output signal controlling the vibration motor
);

    // Define the states for the finite state machine
    reg [1:0] state;  // state register
    parameter S_IDLE = 2'b00;  // idle state
    parameter S_RINGING = 2'b01;  // ringing state

    // Initialize the state register
    initial state = S_IDLE;

    // Define the next state logic
    always @(posedge ring or posedge vibrate_mode) begin
        case (state)
            S_IDLE: begin
                if (ring) begin
                    state <= S_RINGING;
                end else begin
                    state <= S_IDLE;
                end
            end
            S_RINGING: begin
                if (~ring) begin
                    state <= S_IDLE;
                end else begin
                    state <= S_RINGING;
                end
            end
        endcase
    end

    // Define the output logic
    always @(state or vibrate_mode) begin
        case (state)
            S_IDLE: begin
                ringer <= 0;
                motor <= 0;
            end
            S_RINGING: begin
                if (vibrate_mode) begin
                    ringer <= 0;
                    motor <= 1;
                end else begin
                    ringer <= 1;
                    motor <= 0;
                end
            end
        endcase
    end

endmodule