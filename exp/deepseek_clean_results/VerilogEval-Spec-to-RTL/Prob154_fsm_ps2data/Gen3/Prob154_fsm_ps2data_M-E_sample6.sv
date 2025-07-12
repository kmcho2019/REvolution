module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

    reg [23:0] shift_reg;
    reg [1:0] byte_counter;
    reg prev_in3;
    wire start_detect;

    // Edge detection for start condition
    assign start_detect = (~prev_in3) & in[3];

    always @(posedge clk) begin
        if (reset) begin
            shift_reg <= 24'b0;
            byte_counter <= 2'b0;
            done <= 0;
            prev_in3 <= 0;
        end else begin
            prev_in3 <= in[3];
            
            // Shift in new byte and update counter
            shift_reg <= {shift_reg[15:0], in};
            
            // Counter logic
            if (start_detect) begin
                byte_counter <= 2'b1;  // First byte detected
            end else if (|byte_counter) begin
                byte_counter <= byte_counter + 1;
            end
            
            // Done signal generation
            done <= (byte_counter == 2'b10);  // Assert after 3rd byte
            
            // Reset counter after message complete
            if (byte_counter == 2'b10) begin
                byte_counter <= 2'b0;
            end
        end
    end

    // Output is always the shift register (valid when done=1)
    always @(*) begin
        out_bytes = shift_reg;
    end

endmodule