module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  done
);

    // State encoding: 2-bit for clarity
    localparam IDLE       = 2'd0;
    localparam RECEIVING  = 2'd1;
    localparam STOP_WAIT  = 2'd2;

    reg [1:0] state, next_state;
    reg [2:0] bit_counter;  // counts 0 to 7 bits received
    reg [7:0] shift_reg;    // stores received data bits (LSB first)

    always @(posedge clk) begin
        if (reset) begin
            state       <= IDLE;
            bit_counter <= 3'b0;
            shift_reg   <= 8'b0;
            done        <= 1'b0;
        end else begin
            done <= 1'b0;  // default no pulse, set later if needed

            case(state)
                IDLE: begin
                    // Wait for start bit (0)
                    if (in == 1'b0) begin
                        state       <= RECEIVING;
                        bit_counter <= 3'b0;
                        shift_reg   <= 8'b0;
                    end
                end

                RECEIVING: begin
                    // Shift in bits LSB first: shift right, new bit into MSB
                    // This matches LSB first by building from LSB upwards
                    // Actually, for LSB first, shift right is correct if we insert MSB = input bit.
                    // Because bit0 received first ends up in LSB after 8 shifts.

                    shift_reg   <= {in, shift_reg[7:1]};
                    bit_counter <= bit_counter + 1;

                    if (bit_counter == 3'd7) begin
                        // After 8 bits received, check stop bit next cycle
                        state <= STOP_WAIT;
                    end
                end

                STOP_WAIT: begin
                    if (in == 1'b1) begin
                        // Correct stop bit received
                        done  <= 1'b1;
                        state <= IDLE;
                        bit_counter <= 3'b0;
                        shift_reg <= 8'b0;
                    end else begin
                        // Wait until stop bit is detected as 1 (line idle)
                        state <= STOP_WAIT;
                    end
                end

                default: begin
                    state       <= IDLE;
                    bit_counter <= 3'b0;
                    shift_reg   <= 8'b0;
                    done        <= 1'b0;
                end
            endcase
        end
    end

endmodule