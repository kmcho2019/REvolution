module TopModule (
    input        clk,
    input        reset,
    input  [7:0] in,
    output reg [23:0] out_bytes,
    output reg       done
);

    // FSM state encoding
    localparam WAIT_SYNC = 2'd0;
    localparam BYTE2     = 2'd1;
    localparam BYTE3     = 2'd2;

    reg [1:0] state, next_state;
    reg [7:0] byte1, byte2, byte3;

    // Next state logic: evaluate in[3] only in WAIT_SYNC to reduce switching
    always @(*) begin
        case (state)
            WAIT_SYNC: next_state = (in[3]) ? BYTE2 : WAIT_SYNC;
            BYTE2:     next_state = BYTE3;
            BYTE3:     next_state = WAIT_SYNC;
            default:   next_state = WAIT_SYNC;
        endcase
    end

    // Sequential logic: state, byte registers, done and out_bytes update
    always @(posedge clk) begin
        if (reset) begin
            state     <= WAIT_SYNC;
            byte1     <= 8'd0;
            byte2     <= 8'd0;
            byte3     <= 8'd0;
            out_bytes <= 24'd0;
            done      <= 1'b0;
        end else begin
            state <= next_state;
            done  <= 1'b0; // default done low unless asserted below

            case (state)
                WAIT_SYNC: begin
                    if (in[3]) begin
                        byte1 <= in;  // capture first byte only when in[3]==1
                    end
                end
                BYTE2: begin
                    byte2 <= in;     // capture second byte
                end
                BYTE3: begin
                    byte3 <= in;     // capture third byte
                    done <= 1'b1;    // assert done for one cycle
                    out_bytes <= {byte1, byte2, in}; // output concatenated message
                end
                default: begin
                    // Should not happen
                end
            endcase
        end
    end

endmodule