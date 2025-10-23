module TopModule (
    input ring,
    input vibrate_mode,
    output ringer,
    output motor
);

    // State encoding
    localparam IDLE    = 2'b00;
    localparam RINGER  = 2'b01;
    localparam VIBRATE = 2'b10;
    localparam ERROR   = 2'b11;

    reg [1:0] state;

    // Next state logic
    always @(*) begin
        case (state)
            IDLE:    state = ring ? (vibrate_mode ? VIBRATE : RINGER) : IDLE;
            RINGER:  state = ring ? (vibrate_mode ? VIBRATE : RINGER) : IDLE;
            VIBRATE: state = ring ? (vibrate_mode ? VIBRATE : RINGER) : IDLE;
            default: state = ERROR;
        endcase
    end

    // Output logic
    assign ringer = (state == RINGER);
    assign motor  = (state == VIBRATE);

endmodule