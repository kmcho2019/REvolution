module TopModule (
  input clk,
  input in,
  input reset,
  output reg [7:0] out_byte,
  output reg done
);

// Define states
parameter IDLE = 2'b00;
parameter RECEIVING = 2'b01;
parameter STOP_BIT = 2'b10;

reg [1:0] state;
reg [3:0] data_counter;
reg [7:0] data_reg;

always @(posedge clk or posedge reset) begin
  if (reset) begin
    state <= IDLE;
    data_counter <= 0;
    data_reg <= 8'b0;
    done <= 0;
    out_byte <= 8'b0;
  end
  else begin
    case (state)
      IDLE: begin
        if (in == 1'b0) begin
          state <= RECEIVING;
          data_counter <= 0;
        end
      end
      
      RECEIVING: begin
        if (data_counter < 8) begin
          data_reg[data_counter] <= in;
          data_counter <= data_counter + 1;
        end
        else if (in == 1'b1) begin
          out_byte <= data_reg;
          done <= 1;
          state <= STOP_BIT;
        end
      end
      
      STOP_BIT: begin
        if (in == 1'b1) begin
          state <= IDLE;
        end
      end
    endcase
  end
end

endmodule