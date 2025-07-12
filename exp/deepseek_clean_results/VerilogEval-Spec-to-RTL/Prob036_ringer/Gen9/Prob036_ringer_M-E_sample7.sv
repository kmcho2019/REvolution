module TopModule (
    input ring,
    input vibrate_mode,
    output reg ringer,
    output reg motor
);

    // State encoding
    localparam IDLE     = 2'b00;
    localparam RING     = 2'b01;
    localparam VIBRATE  = 2'b10;

    reg [1:0] state;

    always @(*) begin
        case (state)
            IDLE: begin
                ringer = 1'b0;
                motor = 1'b0;
                if (ring) begin
                    state = vibrate_mode ? VIBRATE : RING;
                end else begin
                    state = IDLE;
                end
            end
            RING: begin
                ringer = 1'b1;
                motor = 1'b0;
                state = ring ? (vibrate_mode ? VIBRATE : RING) : IDLE;
            end
            VIBRATE: begin
                ringer = 1'b0;
                motor = 1'b1;
                state = ring ? (vibrate_mode ? VIBRATE : RING) : IDLE;
            end
            default: begin
                ringer = 1'b0;
                motor = 1'b0;
                state = IDLE;
            end
        endcase
    end

endmodule