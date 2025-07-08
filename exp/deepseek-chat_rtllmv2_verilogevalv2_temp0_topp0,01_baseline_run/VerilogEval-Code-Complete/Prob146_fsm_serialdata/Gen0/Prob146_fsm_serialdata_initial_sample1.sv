module TopModule (
  input clk,
  input in,
  input reset,
  output reg [7:0] out_byte,
  output reg done
);

  reg [2:0] bit_counter;
  reg [3:0] state;
  reg [7:0] shift_reg;
  
  // State definitions
  parameter IDLE  = 4'b0000;
  parameter START = 4'b0001;
  parameter DATA  = 4'b0010;
  parameter STOP  = 4'b0100;
  parameter ERROR = 4'b1000;

  always @(posedge clk) begin
    if (reset) begin
      state <= IDLE;
      bit_counter <= 0;
      out_byte <= 0;
      done <= 0;
      shift_reg <= 0;
    end else begin
      done <= 0;  // Default done to 0 unless we're in STOP state with valid stop bit
      
      case (state)
        IDLE: begin
          if (!in) begin  // Start bit detected (0)
            state <= START;
            bit_counter <= 0;
          end
        end
        
        START: begin
          state <= DATA;  // Move to data reception after start bit
        end
        
        DATA: begin
          shift_reg <= {in, shift_reg[7:1]};  // Shift in new bit (LSB first)
          if (bit_counter == 3'd7) begin
            state <= STOP;
          end
          bit_counter <= bit_counter + 1;
        end
        
        STOP: begin
          if (in) begin  // Valid stop bit (1)
            out_byte <= shift_reg;
            done <= 1;
            state <= IDLE;
          end else begin  // Missing stop bit
            state <= ERROR;
          end
        end
        
        ERROR: begin
          if (in) begin  // Line returned to idle (1)
            state <= IDLE;
          end
        end
        
        default: state <= IDLE;
      endcase
    end
  end

endmodule