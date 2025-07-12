module TopModule (
    input ring,
    input vibrate_mode,
    output reg ringer,
    output reg motor
);

    // Simple state machine with two states
    reg state;
    localparam IDLE = 1'b0;
    localparam ACTIVE = 1'b1;

    always @(*) begin
        case (state)
            IDLE: begin
                ringer = 1'b0;
                motor = 1'b0;
            end
            ACTIVE: begin
                ringer = ~vibrate_mode;
                motor = vibrate_mode;
            end
        endcase
    end

    // State transition logic (edge triggered)
    always @(posedge ring) begin
        if (state == IDLE)
            state <= ACTIVE;
        else
            state <= IDLE;
    end

endmodule