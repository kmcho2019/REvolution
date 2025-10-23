module TopModule (
    input         clk,
    input         reset,
    input  [7:0]  in,
    output reg [23:0] out_bytes,
    output reg       done
);

    // One-hot FSM encoding
    localparam WAIT_SYNC = 3'b001;
    localparam BYTE2     = 3'b010;
    localparam BYTE3     = 3'b100;

    reg [2:0] state, next_state;

    // Byte enable signals to reduce toggling in out_bytes
    wire load_byte1, load_byte2, load_byte3;
    assign load_byte1 = (state == WAIT_SYNC) && in[3];
    assign load_byte2 = (state == BYTE2);
    assign load_byte3 = (state == BYTE3);

    // FSM state register
    always @(posedge clk) begin
        if (reset)
            state <= WAIT_SYNC;
        else
            state <= next_state;
    end

    // Datapath registers with enables
    always @(posedge clk) begin
        if (reset) begin
            out_bytes <= 24'd0;
            done      <= 1'b0;
        end else begin
            done <= 1'b0; // default done low, asserted only when third byte loaded

            if (load_byte1)
                out_bytes[23:16] <= in;
            if (load_byte2)
                out_bytes[15:8] <= in;
            if (load_byte3) begin
                out_bytes[7:0] <= in;
                done <= 1'b1;
            end
        end
    end

    // Next state logic with one-hot encoding
    always @(*) begin
        case (state)
            WAIT_SYNC: next_state = in[3] ? BYTE2 : WAIT_SYNC;
            BYTE2:     next_state = BYTE3;
            BYTE3:     next_state = WAIT_SYNC;
            default:   next_state = WAIT_SYNC;
        endcase
    end

endmodule