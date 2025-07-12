module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  done
);

    // Define FSM states using localparam for clarity
    localparam IDLE      = 2'd0;
    localparam RECEIVE   = 2'd1;
    localparam STOP      = 2'd2;
    localparam WAIT_STOP = 2'd3;

    reg [1:0] state, next_state;
    reg [2:0] bit_count;        // Counts 0..7 for 8 data bits
    reg [7:0] data_shift;       // Shift register to store data bits (LSB first)

    // State and data registers
    always @(posedge clk) begin
        if (reset) begin
            state      <= IDLE;
            bit_count  <= 3'd0;
            data_shift <= 8'd0;
            done       <= 1'b0;
        end else begin
            state <= next_state;

            // Default done low; only pulse done in STOP state for one cycle
            done <= 1'b0;

            case (state)
                IDLE: begin
                    bit_count  <= 3'd0;
                    data_shift <= 8'd0;
                    // No shifting; wait for start bit
                end

                RECEIVE: begin
                    // Shift in the incoming bit into LSB side
                    // data_shift = {bit7,...bit1, bit0}
                    // Shift bits left by 1, then place new bit in LSB:
                    data_shift <= {in, data_shift[7:1]}; 
                    // Above shifts MSB-first, so reverse:
                    // Instead shift left by one:
                    // data_shift <= {data_shift[6:0], in};
                    // Replace with correct LSB-first:
                    data_shift <= {data_shift[6:0], in};
                    bit_count <= bit_count + 1;
                end

                STOP: begin
                    // No data shift or count changes
                    // Pulse 'done' for one cycle only if stop bit (in) == 1
                    if (in == 1'b1)
                        done <= 1'b1;
                end

                WAIT_STOP: begin
                    // Wait here until stop bit == 1, then transition to IDLE
                    // No data shift or bit_count changes
                end
            endcase
        end
    end

    // Next state logic: purely combinational
    always @(*) begin
        case (state)
            IDLE: begin
                // Wait for start bit: line idle = 1
                // Transition to RECEIVE only on start bit == 0
                if (in == 1'b0)
                    next_state = RECEIVE;
                else
                    next_state = IDLE;
            end

            RECEIVE: begin
                // After 8 data bits received, move to STOP
                if (bit_count == 3'd7)
                    next_state = STOP;
                else
                    next_state = RECEIVE;
            end

            STOP: begin
                // If stop bit valid (in == 1), done pulse generated in sequential block
                // Move to IDLE for new byte
                // If stop bit invalid (in == 0), move to WAIT_STOP
                if (in == 1'b1)
                    next_state = IDLE;
                else
                    next_state = WAIT_STOP;
            end

            WAIT_STOP: begin
                // Stay here until stop bit == 1
                if (in == 1'b1)
                    next_state = IDLE;
                else
                    next_state = WAIT_STOP;
            end

            default: next_state = IDLE;
        endcase
    end

endmodule