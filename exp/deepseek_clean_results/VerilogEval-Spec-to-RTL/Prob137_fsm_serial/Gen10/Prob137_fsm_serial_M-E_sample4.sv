module TopModule (
    input clk,
    input reset,
    input in,
    output reg done
);

    reg [9:0] shift_reg;  // Stores start(0) + 8 data + stop(1) bits
    reg prev_in;
    reg receiving;

    // Edge detection and shift register
    always @(posedge clk) begin
        if (reset) begin
            shift_reg <= 10'b1111111111; // Initialize to idle state (all 1s)
            prev_in <= 1'b1;
            receiving <= 1'b0;
            done <= 1'b0;
        end else begin
            prev_in <= in;
            
            // Falling edge detection (start bit)
            if (!receiving && prev_in && !in) begin
                receiving <= 1'b1;
                shift_reg <= {9'b111111111, in}; // Start capturing
            end
            // While receiving, shift in bits
            else if (receiving) begin
                shift_reg <= {shift_reg[8:0], in};
                
                // Check for complete byte (10 bits)
                if (shift_reg[9]) begin  // MSB is now the stop bit
                    done <= (in == 1'b1); // Valid if stop bit is 1
                    receiving <= (in != 1'b1); // Stay in receiving if bad stop bit
                end else begin
                    done <= 1'b0;
                end
            end else begin
                done <= 1'b0;
            end
        end
    end

endmodule