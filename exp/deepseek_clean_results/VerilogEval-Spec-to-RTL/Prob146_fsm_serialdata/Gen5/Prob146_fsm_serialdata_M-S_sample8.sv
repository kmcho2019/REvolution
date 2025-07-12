module TopModule (
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

    // Simplified FSM states
    localparam IDLE   = 1'b0;
    localparam RECEIVE = 1'b1;

    reg state, next_state;
    reg [3:0] bit_count; // Counts 0-9 (start + 8 data + stop)
    reg [7:0] shift_reg;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 0;
            shift_reg <= 0;
            out_byte <= 0;
            done <= 0;
        end else begin
            done <= 0;
            case (state)
                IDLE: begin
                    bit_count <= 0;
                    if (!in) begin // Start bit detected
                        state <= RECEIVE;
                        shift_reg <= 0;
                    end
                end

                RECEIVE: begin
                    if (bit_count < 8) begin
                        // Shift in data bits (LSB first)
                        shift_reg <= {in, shift_reg[7:1]};
                        bit_count <= bit_count + 1;
                    end else begin
                        // bit_count == 8 (stop bit)
                        if (in) begin // Valid stop bit
                            out_byte <= shift_reg;
                            done <= 1;
                        end
                        state <= IDLE; // Return to IDLE regardless of stop bit
                    end
                end
            endcase
        end
    end

endmodule