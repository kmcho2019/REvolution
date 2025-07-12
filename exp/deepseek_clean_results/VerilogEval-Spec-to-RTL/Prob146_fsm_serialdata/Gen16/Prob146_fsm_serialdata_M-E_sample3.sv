module TopModule (
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

    // Counter-based state encoding
    // [3]: Valid bit (1 when counting)
    // [2:0]: Bit position (0-7 for data, 8 for stop)
    reg [3:0] counter;

    // Parallel capture register
    reg [7:0] data_buffer;

    // Lookahead register for start bit detection
    reg prev_in;

    always @(posedge clk) begin
        if (reset) begin
            counter <= 4'b0000;
            out_byte <= 8'b0;
            done <= 1'b0;
            prev_in <= 1'b1;
        end else begin
            prev_in <= in;
            done <= 1'b0;

            if (counter[3]) begin  // Active reception
                if (counter[2:0] == 3'b000) begin  // Start bit position
                    if (in == 1'b0) begin
                        counter <= counter + 1;
                    end else begin
                        counter <= 4'b0000;  // Abort if start bit not valid
                    end
                end 
                else if (counter[2:0] < 3'b1000) begin  // Data bits (0-7)
                    data_buffer[counter[2:0]] <= in;  // Parallel capture
                    counter <= counter + 1;
                end 
                else begin  // Stop bit (position 8)
                    if (in == 1'b1) begin
                        out_byte <= data_buffer;
                        done <= 1'b1;
                    end
                    counter <= 4'b0000;  // Return to idle
                end
            end 
            else begin  // IDLE state
                // Edge detection for start bit (falling edge)
                if (prev_in && !in) begin
                    counter <= 4'b1000;  // Set valid bit and start counting
                end
            end
        end
    end

endmodule