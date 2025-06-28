module TopModule (
  input wire clk,
  input wire reset,
  input wire data,
  output reg [3:0] count,
  output reg counting,
  output reg done,
  input wire ack
);

reg [3:0] shift_register = 4'b0;
reg [3:0] delay = 4'b0;
reg [3:0] time_counter = 4'b0;
reg [3:0] remaining_delay = 4'b0;
reg pattern_detected = 1'b0;

always @(posedge clk) begin
    if (reset) begin
        count <= 4'b0;
        counting <= 0;
        done <= 0;
        shift_register <= 4'b0;
        delay <= 4'b0;
        time_counter <= 4'b0;
        remaining_delay <= 4'b0;
        pattern_detected <= 1'b0;
    end
    else begin
        // Shift in data
        shift_register <= {shift_register[2:0], data};

        // Detect pattern 1101
        if (shift_register == 4'b1101 && !pattern_detected) begin
            pattern_detected <= 1'b1;
            delay <= {shift_register[3], shift_register[7:4]};
            counting <= 1;
            remaining_delay <= delay;
        end
        
        // Timer counting
        if (counting) begin
            time_counter <= time_counter + 1;
        
            // Counting logic every 1000 cycles
            if (time_counter % 1000 == 0) begin
                remaining_delay <= remaining_delay - 1;
                count <= remaining_delay;
                
                // Timer finishes counting
                if (remaining_delay == 0) begin
                    done <= 1;
                    counting <= 0;
                end
            end
        end
        
        // Reset after acknowledgment
        if (done && ack) begin
            done <= 0;
            pattern_detected <= 0;
            count <= 4'b0;
            shift_register <= 4'b0;
            delay <= 4'b0;
            time_counter <= 4'b0;
            remaining_delay <= 4'b0;
        end
    end
end

endmodule