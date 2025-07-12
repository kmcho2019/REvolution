module TopModule(
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

    // States
    localparam IDLE    = 1'b0;
    localparam RECEIVE = 1'b1;

    reg state;
    reg [3:0] bit_counter; // Counts 0-8 (start + 8 bits)
    reg [8:0] shift_reg;   // Stores start + 8 data bits
    reg in_prev;           // For edge detection

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_counter <= 4'd0;
            shift_reg <= 9'b0;
            out_byte <= 8'b0;
            done <= 1'b0;
            in_prev <= 1'b1;
        end else begin
            in_prev <= in;
            done <= 1'b0; // Default value

            case (state)
                IDLE: begin
                    // Detect falling edge (start bit)
                    if (in_prev && !in) begin
                        state <= RECEIVE;
                        bit_counter <= 4'd0;
                        shift_reg <= 9'b0;
                    end
                end

                RECEIVE: begin
                    // Shift in current bit
                    shift_reg <= {in, shift_reg[8:1]};
                    bit_counter <= bit_counter + 1;

                    // Check if we've received all bits
                    if (bit_counter == 4'd8) begin
                        // Verify stop bit (current in should be 1)
                        if (in) begin
                            out_byte <= shift_reg[7:0];
                            done <= 1'b1;
                        end
                        state <= IDLE;
                    end
                end
            endcase
        end
    end

endmodule