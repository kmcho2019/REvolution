module TopModule (
  input clk,
  input in,
  input reset,
  output reg [7:0] out_byte,
  output reg done
);

// Define states
parameter IDLE = 3'b000;
parameter DETECT_START_BIT = 3'b001;
parameter RECEIVE_DATA_BITS = 3'b010;
parameter DETECT_STOP_BIT = 3'b011;
parameter WAIT_FOR_IDLE = 3'b100;

// Define signals
reg [2:0] state;
reg [7:0] data_reg;
reg [2:0] data_counter;

always @(posedge clk or posedge reset) begin
  if (reset) begin
    state <= IDLE;
    data_counter <= 3'b000;
    data_reg <= 8'b0;
    done <= 0;
    out_byte <= 8'b0;
  end
  else begin
    case (state)
      IDLE: begin
        if (in == 1'b0) begin
          state <= DETECT_START_BIT;
        end
      end
      
      DETECT_START_BIT: begin
        if (in == 1'b0) begin
          state <= RECEIVE_DATA_BITS;
        end
      end
      
      RECEIVE_DATA_BITS: begin
        data_reg[data_counter] <= in;
        if (data_counter == 7) begin
          state <= DETECT_STOP_BIT;
        end
        else begin
          data_counter <= data_counter + 1;
        end
      end
      
      DETECT_STOP_BIT: begin
        if (in == 1'b1) begin
          out_byte <= data_reg;
          done <= 1;
          state <= WAIT_FOR_IDLE;
        end
      end

      WAIT_FOR_IDLE: begin
        if (in == 1'b1) begin
          state <= IDLE;
        end
      end
    endcase
  end
end

endmodule