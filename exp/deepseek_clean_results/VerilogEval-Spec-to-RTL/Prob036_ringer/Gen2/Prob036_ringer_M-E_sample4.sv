module TopModule (
    input ring,
    input vibrate_mode,
    output reg ringer,
    output reg motor
);

    // Define states
    localparam RINGER = 1'b0;
    localparam VIBRATE = 1'b1;

    reg state;

    always @(*) begin
        case (state)
            RINGER: begin
                ringer = ring & ~vibrate_mode;
                motor = 1'b0;
                if (vibrate_mode) state = VIBRATE;
            end
            VIBRATE: begin
                motor = ring & vibrate_mode;
                ringer = 1'b0;
                if (~vibrate_mode) state = RINGER;
            end
            default: begin
                ringer = 1'b0;
                motor = 1'b0;
                state = RINGER;
            end
        endcase
    end

    initial begin
        state = RINGER;
    end

endmodule