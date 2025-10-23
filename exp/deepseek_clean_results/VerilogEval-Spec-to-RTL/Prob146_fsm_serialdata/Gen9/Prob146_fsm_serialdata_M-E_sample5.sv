module TopModule (
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

    reg [3:0] counter;  // Tracks bit position and state (0=IDLE, 1-8=data, 9=stop)
    reg [8:0] shift_reg; // Stores start bit + 8 data bits

    always @(posedge clk) begin
        if (reset) begin
            counter <= 0;
            shift_reg <= 9'b1_1111_1111; // Initialize to idle state
            out_byte <= 0;
            done <= 0;
        end else begin
            done <= 0;

            if (counter == 0) begin
                // IDLE state - wait for start bit
                if (in == 0) begin
                    counter <= 1;
                    shift_reg <= {8'b0, in}; // Store start bit
                end
            end else if (counter < 9) begin
                // Receiving data bits (1-8)
                shift_reg <= {in, shift_reg[8:1]}; // Shift in LSB first
                counter <= counter + 1;
            end else begin
                // Check stop bit (counter == 9)
                if (in) begin
                    out_byte <= shift_reg[7:0]; // Valid byte received
                    done <= 1;
                end
                counter <= 0; // Return to IDLE regardless of stop bit validity
            end
        end
    end

endmodule