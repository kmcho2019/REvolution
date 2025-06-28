module TopModule (
  input wire clk,
  input wire reset,
  input wire data,
  output reg [3:0] count,
  output reg counting,
  output reg done,
  input wire ack
);
  
reg [3:0] delay;
reg [3:0] shift_reg;
reg [3:0] counter;
reg detect_pattern;
reg [1:0] wait_ack;
reg previous_data;

always @ (posedge clk or posedge reset) begin
  if (reset) begin
    delay <= 4'b0;
    shift_reg <= 4'b0;
    counter <= 4'b0;
    count <= 4'b0;
    counting <= 0;
    done <= 0;
    detect_pattern <= 0;
    wait_ack <= 2'b0;
  end
  else begin
    // Detect pattern 1101
    if (!detect_pattern && previous_data == 3'b110 && data == 1'b1) begin
      detect_pattern <= 1;
      shift_reg <= 4'b0;
    end

    // Shift in the delay duration
    if (detect_pattern && shift_reg < 4) begin
      shift_reg <= {data, shift_reg[3:1]};
    end
    
    if (detect_pattern && shift_reg == 4) begin
      delay <= shift_reg;
      counting <= 1;
    end

    // Timer counting
    if (counting) begin
      if (counter < (delay + 1) * 1000) begin
        counter <= counter + 1;
        if (counter % 1000 == 0) begin
          count <= delay - counter / 1000;
        end
      end
      else begin
        done <= 1;
        wait_ack <= 2'b11;
        counting <= 0;
      end
    end

    // Wait for ack and reset
    if (wait_ack == 2'b11 && ack) begin
      detect_pattern <= 0;
      wait_ack <= 2'b00;
      count <= 4'b0;
      counter <= 4'b0;
    end

    previous_data <= data;
  end
end

endmodule