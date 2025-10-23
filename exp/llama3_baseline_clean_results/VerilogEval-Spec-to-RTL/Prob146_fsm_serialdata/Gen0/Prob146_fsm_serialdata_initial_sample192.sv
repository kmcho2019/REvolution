module TopModule(
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

reg [2:0] state; // States: 0 - Idle, 1 - Start Bit, 2 - Data Bits, 3 - Stop Bit
reg [2:0] bit_counter; // Counter for data bits

always @(posedge clk) begin
    if (reset) begin
        state <= 0; // Reset to idle state
        done <= 0;
        out_byte <= 0;
        bit_counter <= 0;
    end else begin
        case (state)
            0: begin // Idle state
                done <= 0;
                if (~in) begin // Start bit detected
                    state <= 1;
                    bit_counter <= 0;
                end
            end
            1: begin // Start bit detected, start collecting data bits
                out_byte[0] <= in; // Least significant bit first
                bit_counter <= bit_counter + 1;
                if (bit_counter == 1) begin
                    state <= 2;
                end
            end
            2: begin // Collecting data bits
                out_byte[bit_counter] <= in;
                bit_counter <= bit_counter + 1;
                if (bit_counter == 8) begin
                    state <= 3;
                end
            end
            3: begin // Stop bit verification
                if (in) begin // Correct stop bit
                    done <= 1;
                    state <= 0; // Transition back to idle
                end // Else, wait for correct stop bit
            end
            default: state <= 0; // Default to idle state
        endcase
    end
end

// For simulation purposes, you may want to initialize out_byte and done
initial begin
    out_byte = 0;
    done = 0;
end

endmodule