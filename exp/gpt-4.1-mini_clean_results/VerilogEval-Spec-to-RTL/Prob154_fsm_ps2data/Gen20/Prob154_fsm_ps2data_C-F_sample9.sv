module TopModule (
    input         clk,
    input         reset,
    input  [7:0]  in,
    output reg [23:0] out_bytes,
    output reg       done
);

    // FSM state encoding (2-bit binary)
    localparam WAIT_SYNC = 2'd0;
    localparam BYTE2     = 2'd1;
    localparam BYTE3     = 2'd2;

    reg [1:0] state, next_state;

    // Byte load enables derived combinationally from state and input
    wire load_byte1 = (state == WAIT_SYNC) && in[3];
    wire load_byte2 = (state == BYTE2);
    wire load_byte3 = (state == BYTE3);

    // FSM state and datapath sequential logic
    always @(posedge clk) begin
        if (reset) begin
            state     <= WAIT_SYNC;
            out_bytes <= 24'd0;
            done      <= 1'b0;
        end else begin
            state <= next_state;

            // Default done low; assert done only for one cycle immediately after loading third byte
            if (load_byte3) begin
                out_bytes[7:0] <= in;
                done <= 1'b1;
            end else begin
                done <= 1'b0;
            end

            if (load_byte1)
                out_bytes[23:16] <= in;

            if (load_byte2)
                out_bytes[15:8] <= in;
        end
    end

    // Combinational next-state logic
    always @(*) begin
        case (state)
            WAIT_SYNC: next_state = in[3] ? BYTE2 : WAIT_SYNC;
            BYTE2:     next_state = BYTE3;
            BYTE3:     next_state = WAIT_SYNC;
            default:   next_state = WAIT_SYNC;
        endcase
    end

endmodule