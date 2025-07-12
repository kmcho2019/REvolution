module TopModule (
    input ring,
    input vibrate_mode,
    output reg ringer,
    output reg motor
);

    always @(*) begin
        ringer = 1'b0;
        motor = 1'b0;
        
        if (ring) begin
            case (vibrate_mode)
                1'b0: ringer = 1'b1;
                1'b1: motor = 1'b1;
            endcase
        end
    end

endmodule