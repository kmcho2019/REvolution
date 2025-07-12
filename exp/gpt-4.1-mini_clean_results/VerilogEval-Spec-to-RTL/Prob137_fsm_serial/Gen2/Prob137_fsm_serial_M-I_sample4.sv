module TopModule (
    input clk,
    input reset,
    input in,
    output reg done
);

    // States encoded as 2-bit binary
    localparam IDLE = 2'd0;
    localparam DATA = 2'd1;
    localparam STOP = 2'd2;

    reg [1:0] state, next_state;
    reg [2:0] bit_count;     // counts 0 to 7 for 8 bits
    reg [7:0] data_shift;    // stores received byte bits (LSB first)

    // Sequential logic for state transitions and data capturing
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 3'd0;
            data_shift <= 8'd0;
            done <= 1'b0;
        end else begin
            state <= next_state;
            done <= 1'b0; // Default no done each clock

            case (state)
                IDLE: begin
                    bit_count <= 3'd0;
                    data_shift <= 8'd0;
                    // Wait for start bit (in == 0), no data capture here
                end
                DATA: begin
                    // Shift in new bit into LSB position, oldest bits shift up
                    data_shift <= {in, data_shift[7:1]};
                    bit_count <= bit_count + 1;
                end
                STOP: begin
                    // If stop bit (in) is correct (1), pulse done
                    if (in == 1'b1)
                        done <= 1'b1;
                    // If stop bit incorrect, keep done = 0, stay in STOP
                end
                default: begin
                    bit_count <= 3'd0;
                    data_shift <= 8'd0;
                end
            endcase
        end
    end

    // Next state combinational logic
    always @(*) begin
        case (state)
            IDLE: begin
                // Transition to DATA only if start bit detected (0)
                if (in == 1'b0)
                    next_state = DATA;
                else
                    next_state = IDLE;
            end

            DATA: begin
                // After receiving 8 bits (bit_count 7 since counting from 0), go to STOP
                if (bit_count == 3'd7)
                    next_state = STOP;
                else
                    next_state = DATA;
            end

            STOP: begin
                // Stay in STOP while stop bit is 0
                // Transition back to IDLE when stop bit is 1 (valid stop bit)
                if (in == 1'b1)
                    next_state = IDLE;
                else
                    next_state = STOP;
            end

            default: next_state = IDLE;
        endcase
    end

endmodule