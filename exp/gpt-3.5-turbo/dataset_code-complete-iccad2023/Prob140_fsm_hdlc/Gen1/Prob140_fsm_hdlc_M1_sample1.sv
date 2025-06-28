module TopModule (
  input clk,
  input reset,
  input in,
  output reg disc,
  output reg flag,
  output reg err
);

  // Registers for state and shift register
  reg [1:0] state;
  reg [5:0] shift_reg;

  // Moore-type FSM states
  localparam S_IDLE = 2'b00;
  localparam S_FLAG = 2'b01;
  localparam S_ERR = 2'b10;

  // Assign initial states
  always @* begin
    state = S_IDLE;
    disc = 0;
    flag = 0;
    err = 0;
  end

  always @(posedge clk) begin
    if (reset) begin
      state <= S_IDLE;
      shift_reg <= 6'b0;
    end
    else begin
      shift_reg <= {shift_reg[4:0], in};
      case (state)
        S_IDLE: begin
          if (shift_reg == 6'b0111110) begin
            disc <= 1;
            shift_reg <= 6'b0;
          end
          else if (in) begin
            state <= S_FLAG;
          end
        end
        S_FLAG: begin
          if (shift_reg == 6'b01111110) begin
            flag <= 1;
            state <= S_IDLE;
          end
          else if (shift_reg[5] == 1 || (shift_reg == 6'b01111111)) begin
            err <= 1;
            state <= S_ERR;
          end
        end
        S_ERR: begin
          if (shift_reg[5] == 0) begin
            err <= 0;
            state <= S_IDLE;
          end
        end
      endcase
    end
  end

endmodule