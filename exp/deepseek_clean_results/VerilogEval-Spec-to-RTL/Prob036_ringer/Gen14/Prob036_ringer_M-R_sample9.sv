module TopModule (
    input ring,
    input vibrate_mode,
    output reg ringer,
    output reg motor
);

    always @(*) begin
        // Default outputs when not ringing
        ringer = 0;
        motor = 0;
        
        if (ring) begin
            if (vibrate_mode) begin
                motor = 1;
            end else begin
                ringer = 1;
            end
        end
    end

endmodule