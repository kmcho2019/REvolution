module PatternDetection (
  input clk,
  input reset,
  input data,
  output reg pattern_detected
);
  
  reg [1:0] state, next_state;
  
  always @(posedge clk or posedge reset) begin
    if (reset) begin
      state <= 2'b00; // IDLE state
    end else begin
      state <= next_state;
    end
  end
  
  always @* begin
    next_state = state;
    pattern_detected = 0;
    
    case (state)
      2'b00: begin // IDLE state
        if (data == 4'b1101) begin
          next_state = 2'b01; // PATTERN_DETECTED state
        end
      end
      2'b01: begin // PATTERN_DETECTED state
        pattern_detected = 1;
        next_state = 2'b00; // Return to IDLE state
      end
    endcase
  end

endmodule

module TimerControl (
  input clk,
  input reset,
  input pattern_detected,
  output reg shift_ena,
  output reg counting,
  input done_counting,
  output reg done,
  input ack
);

  reg [1:0] state, next_state;
  
  always @(posedge clk or posedge reset) begin
    if (reset) begin
      state <= 2'b00; // IDLE state
    end else begin
      state <= next_state;
    end
  end
  
  always @* begin
    next_state = state;
    shift_ena = 0;
    counting = 0;
    done = 0;
    
    case (state)
      2'b00: begin // IDLE state
        if (pattern_detected) begin
          next_state = 2'b01; // DETECTED_PATTERN state
        end
      end
      2'b01: begin // DETECTED_PATTERN state
        shift_ena = 1;
        next_state = 2'b10; // SHIFT_ENA state
      end
      2'b10: begin // SHIFT_ENA state
        // Add logic to shift in 4 bits
        counting = 1;
        next_state = 2'b11; // COUNTING state
      end
      2'b11: begin // COUNTING state
        if (done_counting) begin
          next_state = 2'b100; // DONE_WAIT state
        end
      end
      2'b100: begin // DONE_WAIT state
        if (ack) begin
          next_state = 2'b101; // DONE_ACK_WAIT state
        end
      end
      2'b101: begin // DONE_ACK_WAIT state
        if (~ack) begin
          next_state = 2'b00; // Return to IDLE state
        end
      end
    endcase
  end
endmodule

module TopModule (
  input clk,
  input reset,
  input data,
  input done_counting,
  input ack,
  output reg shift_ena,
  output reg counting,
  output reg done
);

  wire pattern_detected;
  
  PatternDetection pattern_detect (
    .clk(clk),
    .reset(reset),
    .data(data),
    .pattern_detected(pattern_detected)
  );
  
  TimerControl timer_control (
    .clk(clk),
    .reset(reset),
    .pattern_detected(pattern_detected),
    .shift_ena(shift_ena),
    .counting(counting),
    .done_counting(done_counting),
    .done(done),
    .ack(ack)
  );

endmodule