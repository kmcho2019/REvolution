module TopModule (
    input        clk,
    input        reset,
    input  [7:0] in,
    output reg [23:0] out_bytes,
    output reg       done
);

    // FSM states - binary encoding (2 bits)
    localparam WAIT_SYNC = 2'b00;
    localparam BYTE2     = 2'b01;
    localparam BYTE3     = 2'b10;

    reg [1:0] state, next_state;

    // Byte registers
    reg [7:0] byte1;
    reg [7:0] byte2;

    // Load enables for bytes
    wire load_byte1 = (state == WAIT_SYNC) && in[3];
    wire load_byte2 = (state == BYTE2);
    wire load_byte3 = (state == BYTE3);

    // Sequential logic: state update and byte registers with clock gating
    always @(posedge clk) begin
        if (reset) begin
            state <= WAIT_SYNC;
            byte1 <= 8'd0;
            byte2 <= 8'd0;
            out_bytes <= 24'd0;
            done <= 1'b0;
        end else begin
            state <= next_state;

            if (load_byte1)
                byte1 <= in;

            if (load_byte2)
                byte2 <= in;

            // Only update out_bytes and done when third byte received
            if (load_byte3) begin
                out_bytes <= {byte1, byte2, in};
                done <= 1'b1;
            end else begin
                done <= 1'b0;
            end
        end
    end

    // Next state logic separated combinational block
    always @(*) begin
        case (state)
            WAIT_SYNC: next_state = in[3] ? BYTE2 : WAIT_SYNC;
            BYTE2:     next_state = BYTE3;
            BYTE3:     next_state = WAIT_SYNC;
            default:   next_state = WAIT_SYNC;
        endcase
    end

endmodule