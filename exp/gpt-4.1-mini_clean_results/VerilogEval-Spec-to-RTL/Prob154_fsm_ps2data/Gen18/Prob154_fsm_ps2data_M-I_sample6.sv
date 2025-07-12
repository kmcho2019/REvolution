module TopModule (
    input         clk,
    input         reset,
    input  [7:0]  in,
    output reg [23:0] out_bytes,
    output reg       done
);

    // FSM states
    localparam WAIT_SYNC = 2'd0;
    localparam BYTE2     = 2'd1;
    localparam BYTE3     = 2'd2;

    reg [1:0] state, next_state;

    // Byte load enables
    wire load_byte1 = (state == WAIT_SYNC) && in[3];
    wire load_byte2 = (state == BYTE2);
    wire load_byte3 = (state == BYTE3);

    // Combinational done pulse asserted only when the third byte is loaded
    wire done_pulse = load_byte3;

    always @(posedge clk) begin
        if (reset) begin
            state     <= WAIT_SYNC;
            out_bytes <= 24'd0;
            done      <= 1'b0;
        end else begin
            state <= next_state;

            // default done low, pulse when done_pulse high
            done <= done_pulse;

            // Update only the byte lanes enabled to reduce toggling
            if (load_byte1)
                out_bytes[23:16] <= in;

            if (load_byte2)
                out_bytes[15:8] <= in;

            if (load_byte3)
                out_bytes[7:0] <= in;
        end
    end

    // FSM next state logic
    always @(*) begin
        case (state)
            WAIT_SYNC: next_state = in[3] ? BYTE2 : WAIT_SYNC;
            BYTE2:     next_state = BYTE3;
            BYTE3:     next_state = WAIT_SYNC;
            default:   next_state = WAIT_SYNC;
        endcase
    end

endmodule