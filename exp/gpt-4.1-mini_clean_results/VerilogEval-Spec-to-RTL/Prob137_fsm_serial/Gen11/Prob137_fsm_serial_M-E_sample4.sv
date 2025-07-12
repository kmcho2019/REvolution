module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  done
);

    // State encoding
    localparam [2:0]
        IDLE  = 3'd0,
        DATA  = 3'd1,
        STOP  = 3'd2,
        ERROR = 3'd3;

    reg [2:0] state, next_state;
    reg [7:0] shift_reg;
    reg [3:0] bit_count;  // Enough to count up to 8 bits

    always @(posedge clk) begin
        if (reset) begin
            state     <= IDLE;
            shift_reg <= 8'b0;
            bit_count <= 4'b0;
            done      <= 1'b0;
        end else begin
            done <= 1'b0;  // default: done low unless set below

            case(state)
                IDLE: begin
                    if (in == 1'b0) begin
                        // Start bit detected
                        state     <= DATA;
                        bit_count <= 4'd0;
                        shift_reg <= 8'b0;
                    end
                end

                DATA: begin
                    // Shift incoming bit into LSB position (LSB first)
                    shift_reg <= {in, shift_reg[7:1]};
                    bit_count <= bit_count + 1'b1;

                    if (bit_count == 4'd7) begin
                        // Last data bit received, move to STOP
                        state <= STOP;
                    end
                end

                STOP: begin
                    if (in == 1'b1) begin
                        // Correct stop bit
                        done  <= 1'b1;
                        state <= IDLE;
                    end else begin
                        // Stop bit error: wait for line to return idle (1)
                        state <= ERROR;
                    end
                end

                ERROR: begin
                    if (in == 1'b1) begin
                        // Stop bit detected eventually; go to IDLE to wait for next frame
                        state <= IDLE;
                    end
                end

                default: state <= IDLE;
            endcase
        end
    end

endmodule