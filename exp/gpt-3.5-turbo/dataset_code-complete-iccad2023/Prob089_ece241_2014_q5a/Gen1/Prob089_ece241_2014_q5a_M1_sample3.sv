module TopModule (
  input clk,
  input areset,
  input x,
  output reg z
);

// State declaration
parameter PROCESS = 1'b1;
reg state, next_state;
reg [7:0] count, shift_reg;

always @ (posedge clk or posedge areset) begin
  if (areset) begin
    state <= PROCESS;
    shift_reg <= 8'b0;
    count <= 8'b0;
    z <= 0;
  end
  else begin
    state <= next_state;
    case(state)
      PROCESS: begin
        if (~x) begin
          shift_reg <= {shift_reg[6:0], x};
          count <= count + 1;
        end
        next_state <= PROCESS;
        if (x & (count == 0)) begin
          z <= shift_reg;
          next_state <= PROCESS;
        end
        else if (count > 0) begin
          z <= ~shift_reg + 1;
          next_state <= PROCESS;
        end
      end
    endcase
  end
end

endmodule