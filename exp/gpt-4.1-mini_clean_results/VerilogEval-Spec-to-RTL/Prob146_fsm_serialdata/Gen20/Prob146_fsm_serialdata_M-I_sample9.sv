module TopModule (
    input  wire       clk,
    input  wire       in,
    input  wire       reset,
    output reg  [7:0] out_byte,
    output reg        done
);

    // FSM state encoding (binary)
    localparam IDLE       = 2'd0;
    localparam READ_BITS  = 2'd1;
    localparam CHECK_STOP = 2'd2;
    localparam RECOVER    = 2'd3;

    reg [1:0] state, next_state;
    reg [2:0] bit_cnt;
    reg [7:0] shift_reg;

    wire shift_enable = (state == READ_BITS);
    wire done_pulse;

    // Next state combinational logic: simplified for better PPA
    always @(*) begin
        case (state)
            IDLE:
                next_state = (in == 1'b0) ? READ_BITS : IDLE;

            READ_BITS:
                next_state = (bit_cnt == 3'd7) ? CHECK_STOP : READ_BITS;

            CHECK_STOP:
                next_state = (in == 1'b1) ? IDLE : RECOVER;

            RECOVER:
                next_state = (in == 1'b1) ? IDLE : RECOVER;

            default:
                next_state = IDLE;
        endcase
    end

    // done_pulse combinational: goes high only for one clock cycle on valid stop bit
    assign done_pulse = (state == CHECK_STOP) && (in == 1'b1);

    always @(posedge clk) begin
        if (reset) begin
            state     <= IDLE;
            bit_cnt   <= 3'd0;
            shift_reg <= 8'd0;
            out_byte  <= 8'd0;
            done      <= 1'b0;
        end else begin
            state <= next_state;
            done <= done_pulse;

            // Bit counter and shift register update gated on shift_enable
            if (shift_enable) begin
                // Shift right, insert new bit at MSB for LSB-first serial data reception
                shift_reg <= {in, shift_reg[7:1]};
                bit_cnt <= bit_cnt + 1'b1;
            end else begin
                bit_cnt <= 3'd0;
                // Clear shift_reg only on IDLE to reduce toggling
                if (next_state == IDLE)
                    shift_reg <= 8'd0;
            end

            // Update output byte only when a valid stop bit is detected (done pulse)
            if (done_pulse) begin
                out_byte <= shift_reg;
            end
        end
    end

endmodule