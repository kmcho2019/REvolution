module TopModule (
    input        clk,
    input        reset,
    input  [7:0] in,
    output reg [23:0] out_bytes,
    output        done
);

    // FSM states encoding
    localparam WAIT_SYNC = 2'd0;
    localparam BYTE2     = 2'd1;
    localparam BYTE3     = 2'd2;

    reg [1:0] state, next_state;
    reg [7:0] byte1, byte2, byte3;

    // done is combinational: asserted only during BYTE3 state on current clock cycle
    assign done = (state == BYTE3);

    // Sequential logic: state and byte registers with clock enable signals
    always @(posedge clk) begin
        if (reset) begin
            state <= WAIT_SYNC;
            byte1 <= 8'd0;
            byte2 <= 8'd0;
            byte3 <= 8'd0;
            out_bytes <= 24'd0;
        end else begin
            state <= next_state;

            // Capture bytes conditionally to reduce toggling
            case(state)
                WAIT_SYNC: begin
                    if (in[3]) byte1 <= in;
                end
                BYTE2: begin
                    byte2 <= in;
                end
                BYTE3: begin
                    byte3 <= in;
                    // Update out_bytes only when done (i.e. in BYTE3 state)
                    out_bytes <= {byte1, byte2, in};
                end
                default: ;
            endcase
        end
    end

    // Next state combinational logic
    always @(*) begin
        case(state)
            WAIT_SYNC: next_state = (in[3]) ? BYTE2 : WAIT_SYNC;
            BYTE2:     next_state = BYTE3;
            BYTE3:     next_state = WAIT_SYNC;
            default:   next_state = WAIT_SYNC;
        endcase
    end

endmodule