module TopModule (
  input wire clk,
  input wire reset,
  input wire data,
  output reg [3:0] count,
  output reg counting,
  output reg done,
  input wire ack
);

  typedef enum logic [3:0] {
    IDLE, DETECTING_START, DETECTING_DELAY, COUNTING, DONE_WAIT_ACK, IDLE_WAIT_START
  } state_t;
  
  reg [1:0] state;
  reg [3:0] delay;
  reg [4:0] count_reg;
  reg [3:0] pattern_count;
  
  always @(posedge clk) begin
    if (reset) begin
      state <= IDLE;
      counting <= 0;
      done <= 0;
      count <= 4'bxxxx;
      delay <= 4'b0;
      count_reg <= 5'b0;
      pattern_count <= 4'b0;
    end
    else begin
      case (state)
        IDLE: begin
          if (data == 4'b1101) begin
            state <= DETECTING_START;
          end 
          else begin
            state <= IDLE;
          end
        end
        
        DETECTING_START: begin
          if (pattern_count < 4) begin
            pattern_count <= pattern_count + 1;
          end 
          else begin
            state <= DETECTING_DELAY;
          end
        end
        
        DETECTING_DELAY: begin
          delay <= {data, delay[3:1]};
          count_reg <= (delay + 1) * 1000;
          counting <= 1;
          state <= COUNTING;
        end
        
        COUNTING: begin
          if (count_reg > 0) begin
            count_reg <= count_reg - 1;
          end 
          else begin
            state <= DONE_WAIT_ACK;
            counting <= 0;
            done <= 1;
          end
        end
        
        DONE_WAIT_ACK: begin
          if (ack) begin
            state <= IDLE_WAIT_START;
          end 
          else begin
            state <= DONE_WAIT_ACK;
          end
        end
        
        IDLE_WAIT_START: begin
          if (data == 4'b1101) begin
            state <= DETECTING_START;
            pattern_count <= 0;
          end 
          else begin
            state <= IDLE_WAIT_START;
          end
        end
      endcase
    end
  end

  always @(posedge clk) begin
    if (state == COUNTING) begin
      count <= count_reg[3:0];
    end 
    else begin
      count <= 4'bxxxx;
    end
  end

endmodule