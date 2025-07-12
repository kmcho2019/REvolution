module TopModule(
    input  wire       clk,
    input  wire       in,
    input  wire       reset,
    output reg [7:0]  out_byte,
    output reg        done
);

    // One-hot state encoding for better timing and simplified decoding
    localparam IDLE       = 4'b0001;
    localparam RECEIVE    = 4'b0010;
    localparam STOP_WAIT  = 4'b0100;
    localparam ERROR_WAIT = 4'b1000;

    reg [3:0] state, next_state;

    reg [7:0] data_shift;
    reg [3:0] bit_count;

    // Clock enable signal to gate updates and reduce switching in IDLE and ERROR_WAIT
    wire shift_enable = (state == RECEIVE);
    wire count_enable = (state == RECEIVE);

    // Next state combinational logic
    always @(*) begin
        case(state)
            IDLE: begin
                if (in == 1'b0)       // Start bit detected
                    next_state = RECEIVE;
                else
                    next_state = IDLE;
            end

            RECEIVE: begin
                if (bit_count == 4'd7)
                    next_state = STOP_WAIT;
                else
                    next_state = RECEIVE;
            end

            STOP_WAIT: begin
                if (in == 1'b1)
                    next_state = IDLE;
                else
                    next_state = ERROR_WAIT;
            end

            ERROR_WAIT: begin
                if (in == 1'b1)
                    next_state = IDLE;
                else
                    next_state = ERROR_WAIT;
            end

            default: next_state = IDLE;
        endcase
    end

    // Sequential logic with gated enables and synchronous reset
    always @(posedge clk) begin
        if (reset) begin
            state      <= IDLE;
            data_shift <= 8'd0;
            bit_count  <= 4'd0;
            out_byte   <= 8'd0;
            done       <= 1'b0;
        end else begin
            state <= next_state;

            // Default done low each cycle, pulse only on valid stop bit
            done <= 1'b0;

            if (shift_enable) begin
                // Shift left and insert new bit at LSB for LSB-first reception
                // LSB-first means first received bit goes into bit 0, next bit into bit 1, etc.
                data_shift <= {in, data_shift[7:1]}; // This shifts right and inserts at MSB, which is MSB-first
                // Correction: to receive LSB first, shift right and insert new bit at MSB is wrong.
                // Instead shift left and insert new bit at LSB:
                // Correct implementation:
                // data_shift <= {data_shift[6:0], in};
                // Apply corrected shift operation:
                data_shift <= {data_shift[6:0], in};
            end

            if (count_enable) begin
                bit_count <= bit_count + 1;
            end else if (state == IDLE) begin
                bit_count <= 4'd0;
            end

            if (state == STOP_WAIT) begin
                if (in == 1'b1) begin
                    out_byte <= data_shift;
                    done <= 1'b1;
                end
                // else done remains 0, handled in next_state logic
            end

            if (state == IDLE) begin
                data_shift <= 8'd0; // Clear shift register at idle for clarity
            end
        end
    end

endmodule