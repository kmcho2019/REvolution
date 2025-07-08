module TopModule(
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

    // FSM states
    typedef enum reg [2:0] {
        IDLE  = 3'd0,
        START = 3'd1,
        DATA  = 3'd2,
        STOP  = 3'd3,
        ERROR = 3'd4
    } state_t;

    state_t state, next_state;

    reg [2:0] bit_count;    // counts bits 0 to 7 for data bits
    reg [7:0] data_reg;     // shift register for data bits

    // State transition and output logic
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 3'd0;
            data_reg <= 8'd0;
            out_byte <= 8'd0;
            done <= 1'b0;
        end else begin
            done <= 1'b0;  // default done low, assert only on STOP with valid stop bit

            case(state)
                IDLE: begin
                    if (in == 1'b0) begin
                        // Detected start bit (0)
                        state <= START;
                    end else begin
                        // stay idle while line is high
                        state <= IDLE;
                    end
                end

                START: begin
                    // Confirm start bit is still 0 (should be sampled at next clock)
                    if (in == 1'b0) begin
                        bit_count <= 3'd0;
                        data_reg <= 8'd0;
                        state <= DATA;
                    end else begin
                        // Start bit invalid, back to IDLE
                        state <= IDLE;
                    end
                end

                DATA: begin
                    // Shift in data bit LSB first
                    data_reg <= {in, data_reg[7:1]};
                    if (bit_count == 3'd7) begin
                        state <= STOP;
                    end
                    bit_count <= bit_count + 3'd1;
                end

                STOP: begin
                    if (in == 1'b1) begin
                        // Correct stop bit
                        out_byte <= data_reg;
                        done <= 1'b1;
                        state <= IDLE;
                    end else begin
                        // Invalid stop bit, go to ERROR and wait for stop bit (1)
                        state <= ERROR;
                    end
                end

                ERROR: begin
                    if (in == 1'b1) begin
                        // Found stop bit to resync
                        state <= IDLE;
                    end else begin
                        // Keep waiting in ERROR state until stop bit found
                        state <= ERROR;
                    end
                end

                default: state <= IDLE;
            endcase
        end
    end

endmodule