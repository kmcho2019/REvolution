module TopModule (
    input ring,
    input vibrate_mode,
    output reg ringer,
    output reg motor
);

    // State encoding
    localparam NORMAL = 1'b0;
    localparam VIBRATE = 1'b1;
    
    reg state;

    always @(*) begin
        // State transition
        state = vibrate_mode ? VIBRATE : NORMAL;

        // Output logic
        case (state)
            NORMAL: begin
                ringer = ring;
                motor = 1'b0;
            end
            VIBRATE: begin
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