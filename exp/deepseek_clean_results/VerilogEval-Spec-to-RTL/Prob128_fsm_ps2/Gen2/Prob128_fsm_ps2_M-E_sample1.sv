module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output done
);

    reg [7:0] byte_history [0:2];  // 3-byte shift register
    reg in3_prev;                   // Previous value of in[3]
    reg valid_start;                // Flag for valid message start
    reg [1:0] byte_count;           // Counts 0-2 for message bytes

    // Shift register and edge detection
    always @(posedge clk) begin
        if (reset) begin
            byte_history[0] <= 8'h0;
            byte_history[1] <= 8'h0;
            byte_history[2] <= 8'h0;
            in3_prev <= 1'b0;
            valid_start <= 1'b0;
            byte_count <= 2'b0;
        end else begin
            // Shift in new byte
            byte_history[2] <= byte_history[1];
            byte_history[1] <= byte_history[0];
            byte_history[0] <= in;

            // Detect rising edge of in[3]
            in3_prev <= in[3];
            
            // Message start detection and byte counting
            if (~in3_prev & in[3]) begin
                // Rising edge detected - potential message start
                valid_start <= 1'b1;
                byte_count <= 2'b1;  // This is byte 1
            end else if (valid_start) begin
                if (byte_count == 2'b10) begin
                    // After 3 bytes, reset for next message
                    valid_start <= 1'b0;
                    byte_count <= 2'b0;
                end else begin
                    byte_count <= byte_count + 1'b1;
                end
            end
        end
    end

    // Done is asserted in the same cycle as the third byte
    assign done = valid_start & (byte_count == 2'b10);

endmodule