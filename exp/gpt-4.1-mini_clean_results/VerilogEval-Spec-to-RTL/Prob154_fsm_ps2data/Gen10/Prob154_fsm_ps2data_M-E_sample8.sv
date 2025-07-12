module TopModule (
    input        clk,
    input        reset,
    input  [7:0] in,
    output reg [23:0] out_bytes,
    output reg       done
);

    // One-hot FSM encoding: 4 states
    // IDLE: waiting for sync byte (in[3] == 1)
    // BYTE1: received first byte (sync byte)
    // BYTE2: received second byte
    // DONE: output done pulse and then return to IDLE
    localparam IDLE  = 4'b0001;
    localparam BYTE1 = 4'b0010;
    localparam BYTE2 = 4'b0100;
    localparam DONE  = 4'b1000;

    reg [3:0] state, next_state;

    // Shift register to hold 3 bytes
    reg [7:0] shift_reg [2:0];

    // Next values for shift register (combinational)
    reg [7:0] shift_reg_next [2:0];

    integer i;

    // FSM sequential logic: state update
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            out_bytes <= 24'b0;
            done <= 1'b0;
            for (i=0; i<3; i=i+1) begin
                shift_reg[i] <= 8'b0;
            end
        end else begin
            state <= next_state;
            done <= (next_state == DONE) ? 1'b1 : 1'b0;

            // Update shift register only in BYTE1 and BYTE2 states (when capturing message bytes)
            // Also update in DONE state (the third byte) before asserting done
            if (state == IDLE) begin
                // Clear shift register on IDLE to discard old data
                for (i=0; i<3; i=i+1)
                    shift_reg[i] <= 8'b0;
            end else if (state == BYTE1 || state == BYTE2) begin
                // Shift left, insert new byte at LSB position
                shift_reg[2] <= shift_reg[1];
                shift_reg[1] <= shift_reg[0];
                shift_reg[0] <= in;
            end else if (state == DONE) begin
                // Final byte captured (third byte)
                shift_reg[2] <= shift_reg[1];
                shift_reg[1] <= shift_reg[0];
                shift_reg[0] <= in;
                // Output concatenated bytes: first received byte in shift_reg[2], second in shift_reg[1], third in shift_reg[0]
                out_bytes <= {shift_reg[2], shift_reg[1], in};
            end
        end
    end

    // Next state combinational logic
    always @(*) begin
        case (state)
            IDLE: begin
                if (in[3])
                    next_state = BYTE1;
                else
                    next_state = IDLE;
            end
            BYTE1: next_state = BYTE2;
            BYTE2: next_state = DONE;
            DONE:  next_state = IDLE;
            default: next_state = IDLE;
        endcase
    end

endmodule