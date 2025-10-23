module TopModule(
    input        clk,
    input        reset,
    input  [7:0] in,
    output       done
);

    // State encoding
    localparam WAIT  = 2'b00; // Waiting for start byte (in[3] == 1)
    localparam BYTE2 = 2'b01; // Received first byte, expect second byte
    localparam BYTE3 = 2'b10; // Received second byte, expect third byte

    reg [1:0] state, next_state;

    // Next state logic
    always @(*) begin
        case (state)
            WAIT: begin
                if (in[3])
                    next_state = BYTE2;
                else
                    next_state = WAIT;
            end
            BYTE2: next_state = BYTE3;
            BYTE3: next_state = WAIT;
            default: next_state = WAIT;
        endcase
    end

    // State register update with synchronous reset
    always @(posedge clk) begin
        if (reset)
            state <= WAIT;
        else
            state <= next_state;
    end

    // done pulse when transitioning from BYTE3 to WAIT (third byte received)
    assign done = (state == BYTE3);

endmodule