module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  done
);

    // State encoding (2-bit binary)
    localparam [1:0]
        IDLE  = 2'b00,
        DATA  = 2'b01,
        STOP  = 2'b10,
        ERROR = 2'b11;

    reg [1:0] state, next_state;
    reg [2:0] bit_count;      // Counts from 0 to 7
    reg [7:0] shift_reg;      // Shift register for data bits LSB first

    // Next state combinational logic
    always @(*) begin
        case (state)
            IDLE: begin
                if (in == 1'b0)        // Detect start bit
                    next_state = DATA;
                else
                    next_state = IDLE;
            end
            DATA: begin
                if (bit_count == 3'd7)
                    next_state = STOP;
                else
                    next_state = DATA;
            end
            STOP: begin
                if (in == 1'b1)
                    next_state = IDLE;
                else
                    next_state = ERROR; // Wait for valid stop bit
            end
            ERROR: begin
                if (in == 1'b1)
                    next_state = IDLE;
                else
                    next_state = ERROR;
            end
            default: next_state = IDLE;
        endcase
    end

    // Sequential logic: state, counters, shift register, and done pulse
    always @(posedge clk) begin
        if (reset) begin
            state     <= IDLE;
            bit_count <= 3'd0;
            shift_reg <= 8'd0;
            done      <= 1'b0;
        end else begin
            state <= next_state;

            // Default done stays 0 unless set below
            done <= 1'b0;

            case (state)
                IDLE: begin
                    // Reset counters only when entering IDLE
                    if (next_state == IDLE) begin
                        bit_count <= 3'd0;
                        shift_reg <= 8'd0;
                    end
                end

                DATA: begin
                    // Shift in serial data LSB-first, only update registers here
                    shift_reg <= {shift_reg[6:0], in};
                    bit_count <= bit_count + 1;
                end

                STOP: begin
                    // On valid stop bit, produce done pulse once
                    if (in == 1'b1) begin
                        done <= 1'b1;
                        // Clear bit_count and shift_reg on next cycle (entering IDLE)
                    end
                end

                ERROR: begin
                    // Hold counters to zero until stop bit detected
                    bit_count <= 3'd0;
                    shift_reg <= 8'd0;
                end

                default: begin
                    bit_count <= 3'd0;
                    shift_reg <= 8'd0;
                end
            endcase
        end
    end

endmodule