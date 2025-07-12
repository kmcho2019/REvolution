module TopModule (
    input        clk,
    input        reset,
    input  [7:0] in,
    output reg [23:0] out_bytes,
    output reg       done
);

    // One-hot state encoding
    localparam WAIT_SYNC = 3'b001;
    localparam BYTE2     = 3'b010;
    localparam BYTE3     = 3'b100;

    reg [2:0] state, next_state;

    reg [7:0] byte1, byte2, byte3;

    // Byte registers update enable signals
    wire load_byte1 = (state == WAIT_SYNC) && in[3];
    wire load_byte2 = (state == BYTE2);
    wire load_byte3 = (state == BYTE3);

    // Sequential logic: state update and byte registers
    always @(posedge clk) begin
        if (reset) begin
            state <= WAIT_SYNC;
            byte1 <= 8'd0;
            byte2 <= 8'd0;
            byte3 <= 8'd0;
            out_bytes <= 24'd0;
            done <= 1'b0;
        end else begin
            state <= next_state;

            // Load bytes only when enables are asserted
            if (load_byte1)
                byte1 <= in;

            if (load_byte2)
                byte2 <= in;

            if (load_byte3) begin
                byte3 <= in;
                done <= 1'b1;       // Assert done only one cycle here
                out_bytes <= {byte1, byte2, in};
            end else begin
                done <= 1'b0;
            end
        end
    end

    // Combinational next state logic
    always @(*) begin
        case (state)
            WAIT_SYNC: next_state = in[3] ? BYTE2 : WAIT_SYNC;
            BYTE2:     next_state = BYTE3;
            BYTE3:     next_state = WAIT_SYNC;
            default:   next_state = WAIT_SYNC;
        endcase
    end

endmodule