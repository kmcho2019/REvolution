module TopModule (
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

    reg [3:0] counter;  // Counts 0-9 (needs 4 bits)
    reg [8:0] shift_reg; // Stores start + 8 data + stop bits
    reg active;         // 1-bit state (IDLE=0, ACTIVE=1)

    always @(posedge clk) begin
        if (reset) begin
            counter <= 0;
            shift_reg <= 0;
            active <= 0;
            out_byte <= 0;
            done <= 0;
        end else begin
            done <= 0;

            if (!active) begin
                // IDLE state - wait for start bit
                if (!in) begin
                    active <= 1;
                    counter <= 1;
                    shift_reg <= {8'b0, in}; // Capture start bit
                end
            end else begin
                // ACTIVE state - shift in bits
                shift_reg <= {shift_reg[7:0], in};
                counter <= counter + 1;

                // Check for complete byte
                if (counter == 9) begin
                    if (!shift_reg[8] && in) begin  // Valid start & stop
                        out_byte <= shift_reg[7:0];
                        done <= 1;
                    end
                    // Check for new start bit
                    active <= in; // Stay active if no stop bit (in=0)
                    counter <= !in; // Reset counter if new start detected
                end
            end
        end
    end

endmodule