module TopModule (
    input ring,
    input vibrate_mode,
    output reg ringer,
    output reg motor
);

    // Define states
    localparam RINGER_MODE = 1'b0;
    localparam VIBRATE_MODE = 1'b1;

    reg current_state;

    always @(*) begin
        current_state = vibrate_mode ? VIBRATE_MODE : RINGER_MODE;
        
        case(current_state)
            RINGER_MODE: begin
                ringer = ring;
                motor = 1'b0;
            end
            VIBRATE_MODE: begin
                ringer = 1'b0;
                motor = ring;
            end
            default: begin
                ringer = 1'b0;
                motor = 1'b0;
            end
        endcase
    end

endmodule