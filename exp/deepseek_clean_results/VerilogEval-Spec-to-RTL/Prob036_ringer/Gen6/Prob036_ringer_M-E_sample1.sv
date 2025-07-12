module TopModule (
    input ring,
    input vibrate_mode,
    output ringer,
    output motor
);

    // State encoding
    localparam IDLE  = 2'b00;
    localparam RING  = 2'b01;
    localparam VIB   = 2'b10;
    
    reg [1:0] state;

    always @(*) begin
        case (state)
            IDLE: state = ring ? (vibrate_mode ? VIB : RING) : IDLE;
            RING: state = ring ? (vibrate_mode ? VIB : RING) : IDLE;
            VIB:  state = ring ? (vibrate_mode ? VIB : RING) : IDLE;
            default: state = IDLE;
        endcase
    end

    assign ringer = (state == RING);
    assign motor  = (state == VIB);

endmodule