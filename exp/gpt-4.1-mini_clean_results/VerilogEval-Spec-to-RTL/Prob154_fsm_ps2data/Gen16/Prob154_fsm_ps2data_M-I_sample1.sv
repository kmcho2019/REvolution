module TopModule (
    input         clk,
    input         reset,
    input  [7:0]  in,
    output [23:0] out_bytes,
    output        done
);

    // One-hot FSM states
    localparam WAIT_SYNC = 3'b001;
    localparam BYTE2     = 3'b010;
    localparam BYTE3     = 3'b100;

    reg [2:0] state, next_state;

    // Byte registers to hold message bytes
    reg [7:0] byte1, byte2, byte3;

    // Clock enable for bytes update
    wire load_byte;

    // Next state logic combinational
    always @(*) begin
        case (state)
            WAIT_SYNC: next_state = in[3] ? BYTE2 : WAIT_SYNC;
            BYTE2:     next_state = BYTE3;
            BYTE3:     next_state = WAIT_SYNC;
            default:   next_state = WAIT_SYNC;
        endcase
    end

    // Load byte condition: update byte registers only when consuming a message byte
    assign load_byte = (state == WAIT_SYNC && in[3]) || (state == BYTE2) || (state == BYTE3);

    // Sequential logic: state update and byte registers load
    always @(posedge clk) begin
        if (reset) begin
            state <= WAIT_SYNC;
            byte1 <= 8'd0;
            byte2 <= 8'd0;
            byte3 <= 8'd0;
        end else begin
            state <= next_state;
            if (load_byte) begin
                case (state)
                    WAIT_SYNC: byte1 <= in;
                    BYTE2:     byte2 <= in;
                    BYTE3:     byte3 <= in;
                    default:   ; // no action
                endcase
            end
        end
    end

    // Output concatenation of the three bytes
    assign out_bytes = {byte1, byte2, byte3};

    // done asserted combinationally one cycle after 3rd byte received, i.e., when state==BYTE3 before transition
    assign done = (state == BYTE3);

endmodule