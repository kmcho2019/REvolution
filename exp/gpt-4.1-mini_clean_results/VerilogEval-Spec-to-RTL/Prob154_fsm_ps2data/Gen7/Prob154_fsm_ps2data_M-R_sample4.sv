module TopModule (
    input        clk,
    input        reset,
    input  [7:0] in,
    output reg [23:0] out_bytes,
    output        done
);

    // One-hot FSM state encoding
    localparam WAIT_SYNC_BIT = 3'b001;
    localparam BYTE2_BIT     = 3'b010;
    localparam BYTE3_BIT     = 3'b100;

    reg [2:0] state, next_state;

    reg [7:0] byte1, byte2;

    // Synchronous state update
    always @(posedge clk) begin
        if (reset)
            state <= WAIT_SYNC_BIT;
        else
            state <= next_state;
    end

    // Next state combinational logic
    always @(*) begin
        case (state)
            WAIT_SYNC_BIT: next_state = in[3] ? BYTE2_BIT : WAIT_SYNC_BIT;
            BYTE2_BIT:     next_state = BYTE3_BIT;
            BYTE3_BIT:     next_state = WAIT_SYNC_BIT;
            default:       next_state = WAIT_SYNC_BIT;
        endcase
    end

    // Byte capture logic
    always @(posedge clk) begin
        if (reset) begin
            byte1 <= 8'd0;
            byte2 <= 8'd0;
            out_bytes <= 24'd0;
        end else begin
            // Capture first byte when entering BYTE2 state
            if (state == WAIT_SYNC_BIT && in[3])
                byte1 <= in;
            // Capture second byte in BYTE2 state
            if (state == BYTE2_BIT)
                byte2 <= in;
            // Capture third byte and update out_bytes in BYTE3 state
            if (state == BYTE3_BIT)
                out_bytes <= {byte1, byte2, in};
        end
    end

    // Done is asserted combinationally when the FSM is in BYTE3 state
    assign done = (state == BYTE3_BIT);

endmodule