module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  done
);

    // One-hot style state encoding with individual flags
    reg idle, receive, check_stop, wait_stop;
    reg [7:0] shift_reg;
    reg [2:0] bit_count;

    // Sequential logic: state transitions, shift register update, done pulse
    always @(posedge clk) begin
        if (reset) begin
            // Reset all state flags and registers
            idle       <= 1'b1;
            receive    <= 1'b0;
            check_stop <= 1'b0;
            wait_stop  <= 1'b0;

            shift_reg  <= 8'd0;
            bit_count  <= 3'd0;
            done       <= 1'b0;
        end else begin
            done <= 1'b0;  // Default done low unless set below

            if (idle) begin
                // Wait for start bit (0)
                if (in == 1'b0) begin
                    // Transition to receive state
                    idle       <= 1'b0;
                    receive    <= 1'b1;
                    shift_reg  <= 8'd0;
                    bit_count  <= 3'd0;
                end
                // Remain in idle if input is 1
            end else if (receive) begin
                // Shift left by one, insert incoming bit at LSB (LSB first)
                shift_reg <= {in, shift_reg[7:1]};
                bit_count <= bit_count + 1'b1;

                if (bit_count == 3'd7) begin
                    // All 8 bits received, go to check stop bit
                    receive    <= 1'b0;
                    check_stop <= 1'b1;
                end
            end else if (check_stop) begin
                if (in == 1'b1) begin
                    // Valid stop bit: pulse done and return to idle
                    done       <= 1'b1;
                    check_stop <= 1'b0;
                    idle       <= 1'b1;
                end else begin
                    // Invalid stop bit: go to wait_stop until valid stop bit
                    check_stop <= 1'b0;
                    wait_stop  <= 1'b1;
                end
            end else if (wait_stop) begin
                // Wait for valid stop bit
                if (in == 1'b1) begin
                    wait_stop <= 1'b0;
                    idle      <= 1'b1;
                end
                // Remain in wait_stop if not stop bit
            end else begin
                // Default catch-all: go to idle
                idle       <= 1'b1;
                receive    <= 1'b0;
                check_stop <= 1'b0;
                wait_stop  <= 1'b0;
            end
        end
    end

endmodule