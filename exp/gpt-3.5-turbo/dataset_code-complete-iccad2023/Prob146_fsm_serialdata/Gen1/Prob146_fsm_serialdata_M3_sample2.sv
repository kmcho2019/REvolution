module TopModule (
  input clk,
  input in,
  input reset,
  output reg [7:0] out_byte,
  output reg done
);

// State definition
parameter IDLE = 2'b00;
parameter START_BIT = 2'b01;
parameter DATA = 2'b10;
parameter STOP_BIT = 2'b11;

reg [1:0] state;
reg [2:0] data_counter;
reg [7:0] data_reg;

always @(posedge clk or posedge reset) begin
  if (reset) begin
    state <= IDLE;
    data_counter <= 0;
    data_reg <= 8'b0;
    out_byte <= 8'b0;
    done <= 0;
  end else begin
    case (state)
      IDLE: begin
        if (in == 1'b1) begin
          state <= START_BIT;
          data_reg <= 8'b0;
          data_counter <= 0;
        end
      end
      START_BIT: begin
        if (in == 1'b0) begin
          state <= DATA;
        end
      end
      DATA: begin
        if (data_counter < 8) begin
          data_reg <= {data_reg[6:0], in};
          data_counter <= data_counter + 1;
        end else begin
          state <= STOP_BIT;
        end
      end
      STOP_BIT: begin
        if (in == 1'b1) begin
          out_byte <= data_reg;
          done <= 1;
          state <= IDLE;
        end
      end
    endcase
  end
end

endmodule