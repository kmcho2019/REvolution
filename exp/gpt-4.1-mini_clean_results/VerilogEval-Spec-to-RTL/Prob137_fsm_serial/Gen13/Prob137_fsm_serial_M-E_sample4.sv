module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  done
);

    // State encoding
    typedef enum reg [2:0] {
        IDLE  = 3'd0,
        START = 3'd1,
        DATA  = 3'd2,
        STOP  = 3'd3,
        ERROR = 3'd4
    } state_t;

    state_t state, next_state;

    reg [7:0] data_reg;      // To accumulate received data bits, LSB first
    reg [3:0] bit_count;     // Counts received bits (0 to 7)

    // Sequential FSM and outputs
    always @(posedge clk) begin
        if (reset) begin
            state     <= IDLE;
            data_reg  <= 8'b0;
            bit_count <= 4'd0;
            done      <= 1'b0;
        end else begin
            done <= 1'b0; // Default: done pulse low unless set below

            case(state)
                IDLE: begin
                    if (in == 1'b0) begin
                        // Start bit detected
                        state     <= START;
                    end else begin
                        state <= IDLE;
                    end
                    bit_count <= 4'd0;
                    data_reg  <= 8'b0;
                end

                START: begin
                    // Confirm start bit is still 0 in this cycle; if line glitches, go back to IDLE
                    if (in == 1'b0) begin
                        state <= DATA;
                        bit_count <= 4'd0;
                        data_reg <= 8'b0;
                    end else begin
                        state <= IDLE;
                    end
                end

                DATA: begin
                    // Shift in bits LSB first by shifting right and inserting at MSB
                    data_reg <= {in, data_reg[7:1]};
                    bit_count <= bit_count + 1'b1;

                    if (bit_count == 4'd7) begin
                        state <= STOP;
                    end else begin
                        state <= DATA;
                    end
                end

                STOP: begin
                    if (in == 1'b1) begin
                        // Valid stop bit
                        done <= 1'b1;
                        state <= IDLE;
                    end else begin
                        // Framing error, go to ERROR state
                        state <= ERROR;
                    end
                    bit_count <= 4'd0;
                    data_reg  <= 8'b0;
                end

                ERROR: begin
                    // Wait for line to return to idle (1) before trying again
                    if (in == 1'b1) begin
                        state <= IDLE;
                    end else begin
                        state <= ERROR;
                    end
                    bit_count <= 4'd0;
                    data_reg  <= 8'b0;
                end

                default: begin
                    state <= IDLE;
                    bit_count <= 4'd0;
                    data_reg  <= 8'b0;
                    done <= 1'b0;
                end
            endcase
        end
    end

endmodule