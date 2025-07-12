module TopModule (
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

    reg receiving;          // 0 = idle, 1 = receiving a byte
    reg [3:0] bit_count;    // Counts bits received: 0 = waiting for start, 1..8 = data bits, 9 = stop bit
    reg [7:0] shift_reg;    // Shift register for data bits (LSB first)
    reg wait_for_stop;      // flag to indicate waiting to detect stop bit after frame error

    always @(posedge clk) begin
        if (reset) begin
            receiving   <= 1'b0;
            bit_count   <= 4'd0;
            shift_reg   <= 8'd0;
            out_byte    <= 8'd0;
            done        <= 1'b0;
            wait_for_stop <= 1'b0;
        end else begin
            done <= 1'b0;  // default done low
            
            if (wait_for_stop) begin
                // We are waiting for stop bit after a frame error (bad stop bit)
                if (in == 1'b1) begin
                    // Stop bit detected, clear error and return to idle
                    wait_for_stop <= 1'b0;
                    receiving <= 1'b0;
                    bit_count <= 4'd0;
                    shift_reg <= 8'd0;
                end
                // else keep waiting for stop bit to recover
            end else if (!receiving) begin
                // Idle: line should be high (idle), detect start bit (0)
                if (in == 1'b0) begin
                    // Start bit detected, begin receiving
                    receiving <= 1'b1;
                    bit_count <= 4'd1;   // count start bit as first bit
                    shift_reg <= 8'd0;
                end
            end else begin
                // Receiving data bits or stop bit
                bit_count <= bit_count + 4'd1;
                
                if (bit_count >= 1 && bit_count <= 8) begin
                    // Data bits 1..8 (LSB first)
                    // Shift in the bit at LSB
                    // On first data bit (bit_count=1), shift_reg was zero; shift right inserting new bit at MSB is wrong
                    // shift left by 1 and insert new bit at LSB to maintain LSB first ordering
                    shift_reg <= {in, shift_reg[7:1]};
                end else if (bit_count == 9) begin
                    // Stop bit expected
                    if (in == 1'b1) begin
                        // Correct stop bit - byte received successfully
                        out_byte <= shift_reg;
                        done <= 1'b1;
                        // Return to idle
                        receiving <= 1'b0;
                        bit_count <= 4'd0;
                    end else begin
                        // Bad stop bit - enter wait_for_stop to wait for recovery
                        wait_for_stop <= 1'b1;
                        receiving <= 1'b0;
                        bit_count <= 4'd0;
                        shift_reg <= 8'd0;
                    end
                end
            end
        end
    end

endmodule