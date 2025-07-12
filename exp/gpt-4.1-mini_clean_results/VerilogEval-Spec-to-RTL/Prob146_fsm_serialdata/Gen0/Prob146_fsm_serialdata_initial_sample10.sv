module TopModule(
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);
    localparam IDLE      = 2'd0;
    localparam RECEIVE   = 2'd1;
    localparam CHECK_STOP= 2'd2;
    localparam WAIT_STOP = 2'd3;

    reg [1:0] state, next_state;
    reg [2:0] bit_cnt;
    reg [7:0] shift_reg;

    // State transition and outputs
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_cnt <= 3'd0;
            shift_reg <= 8'd0;
            out_byte <= 8'd0;
            done <= 1'b0;
        end else begin
            done <= 1'b0; // default done to 0 every cycle unless set below
            case(state)
                IDLE: begin
                    if (in == 1'b0) begin
                        // Start bit detected, start receiving data bits next cycle
                        state <= RECEIVE;
                        bit_cnt <= 3'd0;
                        shift_reg <= 8'd0;
                    end else begin
                        state <= IDLE;
                    end
                end

                RECEIVE: begin
                    // Shift in data bit LSB first
                    shift_reg <= {in, shift_reg[7:1]};
                    if (bit_cnt == 3'd7) begin
                        state <= CHECK_STOP;
                    end else begin
                        bit_cnt <= bit_cnt + 1;
                        state <= RECEIVE;
                    end
                end

                CHECK_STOP: begin
                    if (in == 1'b1) begin
                        // Valid stop bit
                        out_byte <= shift_reg;
                        done <= 1'b1;
                        state <= IDLE;
                    end else begin
                        // Invalid stop bit, wait until line returns to 1 (stop bit)
                        state <= WAIT_STOP;
                    end
                end

                WAIT_STOP: begin
                    if (in == 1'b1) begin
                        // Stop bit found, go back to IDLE
                        state <= IDLE;
                    end else begin
                        state <= WAIT_STOP;
                    end
                end

                default: state <= IDLE;
            endcase
        end
    end

endmodule