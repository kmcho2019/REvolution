module TopModule (
    input        clk,
    input        reset,
    input  [7:0] in,
    output reg [23:0] out_bytes,
    output reg       done
);

    // FSM states - binary encoding
    localparam WAIT_SYNC = 2'd0;
    localparam BYTE2     = 2'd1;
    localparam BYTE3     = 2'd2;

    reg [1:0] state, next_state;

    // Next state logic
    always @(*) begin
        case (state)
            WAIT_SYNC: next_state = in[3] ? BYTE2 : WAIT_SYNC;
            BYTE2:     next_state = BYTE3;
            BYTE3:     next_state = WAIT_SYNC;
            default:   next_state = WAIT_SYNC;
        endcase
    end

    // Sequential logic: state update, out_bytes loading, done signal
    always @(posedge clk) begin
        if (reset) begin
            state     <= WAIT_SYNC;
            out_bytes <= 24'd0;
            done      <= 1'b0;
        end else begin
            state <= next_state;

            // Load and shift bytes only in states BYTE2 and BYTE3 or when starting message in WAIT_SYNC with in[3] set
            if ((state == WAIT_SYNC && in[3]) || (state == BYTE2) || (state == BYTE3)) begin
                out_bytes <= {out_bytes[15:0], in};
            end

            // done asserted immediately after third byte loaded: on state BYTE3 before transition to WAIT_SYNC
            done <= (state == BYTE3);
        end
    end

endmodule