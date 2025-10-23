module TopModule (
    input         clk,
    input         reset,
    input  [7:0]  in,
    output [23:0] out_bytes,
    output        done
);

    // FSM state encoding
    localparam WAIT_SYNC = 2'd0;
    localparam BYTE2     = 2'd1;
    localparam BYTE3     = 2'd2;

    reg [1:0] state, next_state;

    // Registers for the 3 message bytes
    reg [7:0] byte1, byte2, byte3;

    // State update sequential block
    always @(posedge clk) begin
        if (reset) begin
            state <= WAIT_SYNC;
            byte1 <= 8'd0;
            byte2 <= 8'd0;
            byte3 <= 8'd0;
        end else begin
            state <= next_state;
            case(state)
                WAIT_SYNC: begin
                    if (in[3]) byte1 <= in;
                end
                BYTE2: begin
                    byte2 <= in;
                end
                BYTE3: begin
                    byte3 <= in;
                end
            endcase
        end
    end

    // Next state combinational logic
    always @(*) begin
        case(state)
            WAIT_SYNC: next_state = in[3] ? BYTE2 : WAIT_SYNC;
            BYTE2:     next_state = BYTE3;
            BYTE3:     next_state = WAIT_SYNC;
            default:   next_state = WAIT_SYNC;
        endcase
    end

    // done is high for exactly one cycle immediately after third byte is latched
    assign done = (state == BYTE3);

    // Concatenate bytes for output
    assign out_bytes = {byte1, byte2, byte3};

endmodule