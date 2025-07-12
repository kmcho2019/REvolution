module TopModule(
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

    // States definition
    localparam IDLE  = 3'd0;
    localparam START = 3'd1;
    localparam DATA  = 3'd2;
    localparam STOP  = 3'd3;
    localparam ERROR = 3'd4;

    reg [2:0] state, next_state;
    reg [2:0] bit_cnt;       // counts 0 to 7 for data bits
    reg [7:0] data_reg;

    always @(posedge clk) begin
        if (reset) begin
            state    <= IDLE;
            bit_cnt  <= 3'd0;
            data_reg <= 8'd0;
            done     <= 1'b0;
            out_byte <= 8'd0;
        end else begin
            done <= 1'b0; // Default deassert done

            case (state)
                IDLE: begin
                    // Wait for start bit (in == 0)
                    if (in == 1'b0)
                        state <= START;
                end

                START: begin
                    // Confirm start bit remains low (sanity check)
                    // If line goes high prematurely, false start - return to IDLE
                    if (in == 1'b0) begin
                        bit_cnt  <= 3'd0;
                        data_reg <= 8'd0;
                        state    <= DATA;
                    end else begin
                        // False start, back to IDLE
                        state <= IDLE;
                    end
                end

                DATA: begin
                    // Shift in LSB first
                    // Shift right, load new bit into MSB: data_reg = {in, data_reg[7:1]}
                    // But since protocol is LSB first, shift right
                    data_reg <= {in, data_reg[7:1]};
                    bit_cnt <= bit_cnt + 1'b1;

                    if (bit_cnt == 3'd7)
                        state <= STOP; // After receiving last bit
                end

                STOP: begin
                    if (in == 1'b1) begin
                        // Valid stop bit
                        out_byte <= data_reg;
                        done <= 1'b1;
                        state <= IDLE;
                    end else begin
                        // Invalid stop bit, enter ERROR state
                        state <= ERROR;
                    end
                end

                ERROR: begin
                    // Wait for line to return to idle (high)
                    if (in == 1'b1)
                        state <= IDLE;
                end

                default: state <= IDLE;
            endcase
        end
    end

endmodule