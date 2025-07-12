module TopModule (
    input        clk,
    input        reset,
    input  [7:0] in,
    output       done
);

    typedef enum reg [1:0] {
        IDLE  = 2'b00,
        BYTE2 = 2'b01,
        BYTE3 = 2'b10
    } state_t;

    reg [1:0] state, next_state;

    // State transition logic
    always @(*) begin
        case (state)
            IDLE:  next_state = in[3] ? BYTE2 : IDLE;
            BYTE2: next_state = BYTE3;
            BYTE3: next_state = in[3] ? BYTE2 : IDLE;
            default: next_state = IDLE;
        endcase
    end

    // Synchronous state register update
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
        end else begin
            state <= next_state;
        end
    end

    // done signal: asserted for one cycle after receiving third byte (when leaving BYTE3)
    assign done = (state == BYTE3);

endmodule