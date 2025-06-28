module TopModule (
  input clk,
  input in,
  input reset,
  output reg [7:0] out_byte,
  output reg done
);

  // State definition
  parameter IDLE = 3'b000;
  parameter START_BIT = 3'b001;
  parameter RECEIVE = 3'b010;
  parameter CHECK_STOP_BIT = 3'b011;

  reg [2:0] state;
  reg [7:0] shift_reg;
  reg [2:0] bit_counter;

  always @(posedge clk or posedge reset) begin
    if (reset) begin
      state <= IDLE;
      shift_reg <= 8'b0;
      bit_counter <= 3'b000;
      out_byte <= 8'b0;
      done <= 0;
    end else begin
      case (state)
        IDLE: begin
          if (in == 1'b0) begin
            state <= START_BIT;
            shift_reg <= 8'b0;
            bit_counter <= 3'b000;
          end
        end
        START_BIT: begin
          if (in == 1'b0) begin
            state <= RECEIVE;
          end else begin
            state <= IDLE;
          end
        end
        RECEIVE: begin
          shift_reg <= {in, shift_reg[7:1]};
          bit_counter <= bit_counter + 1;
          if (bit_counter == 3'b111) begin
            state <= CHECK_STOP_BIT;
          end
        end
        CHECK_STOP_BIT: begin
          if (in == 1'b1) begin
            out_byte <= shift_reg;
            done <= 1;
            state <= IDLE;
          end else begin
            state <= IDLE;
          end
        end
      endcase
    end
  end

endmodule