module TopModule (
    input  wire       clk,
    input  wire       in,
    input  wire       reset,
    output reg  [7:0] out_byte,
    output reg        done
);

    // One-hot state encoding
    localparam IDLE       = 4'b0001;
    localparam READ_BITS  = 4'b0010;
    localparam CHECK_STOP = 4'b0100;
    localparam RECOVER    = 4'b1000;

    reg [3:0] state, next_state;
    reg [2:0] bit_cnt;
    reg [7:0] shift_reg;
    reg       done_latched; // latch done to reduce toggling

    // State register and bit counter update
    always @(posedge clk) begin
        if (reset) begin
            state      <= IDLE;
            bit_cnt    <= 3'd0;
            done_latched <= 1'b0;
            out_byte   <= 8'd0;
        end else begin
            state <= next_state;

            if (state == READ_BITS) begin
                bit_cnt <= bit_cnt + 1'b1;
            end else if (state == IDLE || state == RECOVER) begin
                bit_cnt <= 3'd0;
            end

            // Latch done and output only when new valid byte is found
            if (done_latched) begin
                done <= 1'b1;
            end else begin
                done <= 1'b0;
            end

            // Clear done_latched when new start bit detected (ready for next byte)
            if (state == IDLE && in == 1'b0) begin
                done_latched <= 1'b0;
            end
        end
    end

    // Shift register update: separate always block to reduce critical path
    always @(posedge clk) begin
        if (reset) begin
            shift_reg <= 8'd0;
        end else if (state == READ_BITS) begin
            // Shift in LSB first: incoming bit becomes the MSB after right shift
            // So shift right and insert new bit at MSB
            shift_reg <= {in, shift_reg[7:1]};
        end else if (state == IDLE) begin
            shift_reg <= 8'd0;
        end
    end

    // Next state logic combinational
    always @(*) begin
        next_state = IDLE; // default
        case(state)
            IDLE: begin
                // Wait for start bit (0)
                next_state = (in == 1'b0) ? READ_BITS : IDLE;
            end
            READ_BITS: begin
                // After receiving 8 bits, check stop bit
                next_state = (bit_cnt == 3'd7) ? CHECK_STOP : READ_BITS;
            end
            CHECK_STOP: begin
                if (in == 1'b1) begin
                    next_state = IDLE;
                end else begin
                    next_state = RECOVER;
                end
            end
            RECOVER: begin
                // Stay here until line idle (stop bit detected)
                next_state = (in == 1'b1) ? IDLE : RECOVER;
            end
            default: next_state = IDLE;
        endcase
    end

    // done_latched and out_byte update synchronous with state transitions
    always @(posedge clk) begin
        if (reset) begin
            done_latched <= 1'b0;
            out_byte <= 8'd0;
        end else begin
            if (state == CHECK_STOP) begin
                if (in == 1'b1) begin
                    done_latched <= 1'b1;
                    out_byte <= shift_reg;
                end
                // If stop bit invalid, do not assert done_latched or update out_byte
            end
        end
    end

endmodule