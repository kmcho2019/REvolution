module TopModule(
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

    // FSM states with one-hot encoding for better timing
    localparam IDLE      = 3'b001;
    localparam PRE_START = 3'b010;
    localparam RECEIVE   = 3'b100;

    reg [2:0] state;
    reg [2:0] bit_count;
    reg [7:0] shift_reg;
    reg shift_enable;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 3'b0;
            shift_reg <= 8'b0;
            out_byte <= 8'b0;
            done <= 1'b0;
            shift_enable <= 1'b0;
        end else begin
            // Default assignments
            done <= 1'b0;
            shift_enable <= 1'b0;

            case (state)
                IDLE: begin
                    if (!in) begin
                        state <= PRE_START;
                        bit_count <= 3'd7; // Prepare to receive 8 bits
                    end
                end

                PRE_START: begin
                    // Confirm start bit after initial detection
                    if (!in) begin
                        state <= RECEIVE;
                        shift_enable <= 1'b1;
                        shift_reg <= 8'b0; // Clear shift register
                    end else begin
                        state <= IDLE;
                    end
                end

                RECEIVE: begin
                    if (bit_count > 0) begin
                        // Normal data reception
                        shift_enable <= 1'b1;
                        shift_reg <= {in, shift_reg[7:1]};
                        bit_count <= bit_count - 1;
                    end else begin
                        // Last data bit and stop bit check
                        if (in) begin // Valid stop bit
                            out_byte <= {in, shift_reg[7:1]};
                            done <= 1'b1;
                            state <= IDLE;
                        end else begin
                            // Invalid stop bit - treat as new start
                            bit_count <= 3'd7;
                            shift_reg <= 8'b0;
                        end
                    end
                end
            endcase
        end
    end

endmodule