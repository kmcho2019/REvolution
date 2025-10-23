module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  done
);

    // State encoding
    localparam IDLE  = 2'd0,
               DATA  = 2'd1,
               STOP  = 2'd2,
               ERROR = 2'd3;

    reg [1:0] state = IDLE;
    reg [2:0] bit_count = 3'd0;
    reg [7:0] shift_reg = 8'd0;

    always @(posedge clk) begin
        if (reset) begin
            state     <= IDLE;
            bit_count <= 3'd0;
            shift_reg <= 8'd0;
            done      <= 1'b0;
        end else begin
            done <= 1'b0; // default done low each cycle

            case(state)
                IDLE: begin
                    // Wait for start bit (0)
                    if (in == 1'b0) begin
                        state <= DATA;
                        bit_count <= 3'd0;
                        shift_reg <= 8'd0;
                    end else begin
                        state <= IDLE;
                        // hold counters and shift_reg steady to avoid toggling
                    end
                end

                DATA: begin
                    // Shift in LSB first: shift left and insert new bit at LSB
                    shift_reg <= {shift_reg[6:0], in};
                    bit_count <= bit_count + 1'b1;
                    if (bit_count == 3'd7)
                        state <= STOP;
                    else
                        state <= DATA;
                end

                STOP: begin
                    if (in == 1'b1) begin
                        done <= 1'b1;    // pulse done for 1 clock cycle
                        state <= IDLE;
                        // Reset counters and shift_reg next cycle in IDLE
                    end else begin
                        state <= ERROR;  // framing error, wait for stop bit
                    end
                    // Keep counters steady here, clearing in IDLE or ERROR
                end

                ERROR: begin
                    // Stay in ERROR until stop bit detected
                    if (in == 1'b1) begin
                        state <= IDLE;
                        // Reset counters and shift_reg in IDLE
                    end else begin
                        state <= ERROR;
                        // hold counters and shift_reg steady
                    end
                end

                default: begin
                    state <= IDLE;
                    bit_count <= 3'd0;
                    shift_reg <= 8'd0;
                end
            endcase
        end
    end

endmodule