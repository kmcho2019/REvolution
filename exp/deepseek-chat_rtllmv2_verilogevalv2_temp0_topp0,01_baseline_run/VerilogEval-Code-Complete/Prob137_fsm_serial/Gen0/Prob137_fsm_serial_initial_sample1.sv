module TopModule (
  input clk,
  input in,
  input reset,
  output done
);

  // State encoding
  localparam IDLE  = 3'b000;
  localparam START = 3'b001;
  localparam DATA  = 3'b010;
  localparam STOP  = 3'b011;
  localparam ERROR = 3'b100;

  reg [2:0] state, next_state;
  reg [2:0] bit_count;
  reg done_reg;

  // State transition and output logic
  always @(posedge clk) begin
    if (reset) begin
      state <= IDLE;
      bit_count <= 3'b0;
      done_reg <= 1'b0;
    end else begin
      state <= next_state;
      done_reg <= 1'b0;

      case (state)
        IDLE: begin
          bit_count <= 3'b0;
          if (~in) next_state <= START;
          else next_state <= IDLE;
        end

        START: begin
          if (in) next_state <= IDLE;  // False start
          else next_state <= DATA;
        end

        DATA: begin
          if (bit_count == 3'b111) begin
            next_state <= STOP;
          end else begin
            bit_count <= bit_count + 1;
            next_state <= DATA;
          end
        end

        STOP: begin
          if (in) begin
            done_reg <= 1'b1;
            next_state <= IDLE;
          end else begin
            next_state <= ERROR;
          end
        end

        ERROR: begin
          if (in) next_state <= IDLE;
          else next_state <= ERROR;
        end

        default: next_state <= IDLE;
      endcase
    end
  end

  assign done = done_reg;

endmodule