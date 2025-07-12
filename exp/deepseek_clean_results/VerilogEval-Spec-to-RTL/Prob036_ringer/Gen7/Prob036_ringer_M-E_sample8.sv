module TopModule (
    input ring,
    input vibrate_mode,
    output reg ringer,
    output reg motor
);

    // State definitions
    localparam IDLE = 1'b0;
    localparam ALERT = 1'b1;
    
    reg state;
    
    always @(*) begin
        case (state)
            IDLE: begin
                ringer = 1'b0;
                motor = 1'b0;
            end
            ALERT: begin
                ringer = ~vibrate_mode;
                motor = vibrate_mode;
            end
        endcase
    end
    
    always @(*) begin
        if (ring) begin
            state = ALERT;
        end else begin
            state = IDLE;
        end
    end

endmodule