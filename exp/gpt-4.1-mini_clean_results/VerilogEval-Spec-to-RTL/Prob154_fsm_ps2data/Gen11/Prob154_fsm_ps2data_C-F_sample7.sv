module TopModule (
    input        clk,
    input        reset,
    input  [7:0] in,
    output reg [23:0] out_bytes,
    output reg       done
);

    // FSM states - binary encoding
    localparam WAIT_SYNC = 2'd0;
    localparam BYTE2     = 2'd1;
    localparam BYTE3     = 2'd2;

    reg [1:0] state, next_state;
    reg load_shift;  // load enable for shifting in bytes

    // Sequential block: state update, shift register load, done generation
    always @(posedge clk) begin
        if (reset) begin
            state     <= WAIT_SYNC;
            out_bytes <= 24'd0;
            done      <= 1'b0;
        end else begin
            state <= next_state;

            if (load_shift) begin
                // Shift in new byte: first byte into highest 8 bits, then shift left 8 bits per byte
                out_bytes <= {out_bytes[15:0], in};
            end

            // done asserted only on the cycle the third byte is loaded (state BYTE3)
            done <= (state == BYTE3) && load_shift;
        end
    end

    // Next state and load_shift combinational logic
    always @(*) begin
        // Default values
        next_state = state;
        load_shift = 1'b0;

        case (state)
            WAIT_SYNC: begin
                if (in[3]) begin
                    next_state = BYTE2;
                    load_shift = 1'b1;  // load first byte of message
                end
            end

            BYTE2: begin
                next_state = BYTE3;
                load_shift = 1'b1;  // load second byte
            end

            BYTE3: begin
                next_state = WAIT_SYNC;
                load_shift = 1'b1;  // load third byte
            end

            default: begin
                next_state = WAIT_SYNC;
                load_shift = 1'b0;
            end
        endcase
    end

endmodule