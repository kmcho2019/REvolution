module TopModule (
    input clk,
    input reset,
    input in,
    output done
);

    // One-hot encoded states
    localparam IDLE = 3'b001;
    localparam DATA = 3'b010;
    localparam STOP = 3'b100;

    reg [2:0] state, next_state;

    // Bit counter for DATA state (0 to 7)
    reg [2:0] bit_count;

    // Shift register for data bits (captured LSB first)
    reg [7:0] data_shift;

    // done pulse register
    reg done_reg;

    // State register
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 3'd0;
            data_shift <= 8'd0;
            done_reg <= 1'b0;
        end else begin
            state <= next_state;
            done_reg <= 1'b0; // default no done pulse

            case (state)
                IDLE: begin
                    if (in == 1'b0) begin
                        // Start bit detected, prepare for data reception
                        bit_count <= 3'd0;
                        data_shift <= 8'd0;
                    end
                end
                DATA: begin
                    // Shift in new bit at LSB (bit 0), shift right the register
                    // New bit goes into MSB since LSB is bit 0? Actually, LSB first means first bit received is bit 0, so shift right: data_shift = {in, data_shift[7:1]} would shift MSB first. Instead shift left, with in at LSB: data_shift = {in, data_shift[7:1]} reversed, so better to do data_shift = {in, data_shift[7:1]} shifts MSB first.
                    // Actually, better to shift right and load LSB = in:
                    // Let's do: data_shift <= {in, data_shift[7:1]} shifts in at MSB, which is wrong for LSB first.
                    // So shift right: data_shift <= {data_shift[6:0], in};
                    // This way, first bit received goes into bit 0 (LSB).
                    data_shift <= {data_shift[6:0], in};
                    bit_count <= bit_count + 1'b1;
                end
                STOP: begin
                    // If stop bit correct, done pulse one cycle
                    if (in == 1'b1) begin
                        done_reg <= 1'b1;
                    end
                    // else stay in STOP until stop bit arrives
                end
            endcase
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            IDLE: begin
                // Wait for start bit (0)
                if (in == 1'b0)
                    next_state = DATA;
                else
                    next_state = IDLE;
            end
            DATA: begin
                // After 8 bits received, go to STOP
                if (bit_count == 3'd7)
                    next_state = STOP;
                else
                    next_state = DATA;
            end
            STOP: begin
                // If stop bit == 1, go back to IDLE
                // else wait here for valid stop bit
                if (in == 1'b1)
                    next_state = IDLE;
                else
                    next_state = STOP;
            end
            default: next_state = IDLE;
        endcase
    end

    assign done = done_reg;

endmodule