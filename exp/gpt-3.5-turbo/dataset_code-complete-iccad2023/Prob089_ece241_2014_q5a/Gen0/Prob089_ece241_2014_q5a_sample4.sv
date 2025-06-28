module TopModule (
  input clk,
  input areset,
  input x,
  output reg z
);

// State enum
typedef enum logic [1:0] {
  IDLE,
  CONVERT
} state_t;

// Registers
reg [3:0] count;
reg [3:0] input_buffer;
reg [1:0] state;

// State machine
always @(posedge clk or posedge areset) begin
  if (areset) begin
    state <= IDLE;
    count <= 0;
    input_buffer <= 0;
    z <= 0;
  end else begin
    case (state)
      IDLE:
        if (~areset && x) begin
          state <= CONVERT;
          count <= 0;
          input_buffer <= x;
        end
      CONVERT:
        if (count == 4) begin
          z <= ~input_buffer + 1;
          if (areset || ~x) begin
            state <= IDLE;
            count <= 0;
            input_buffer <= 0;
          end
        end else begin
          input_buffer <= {input_buffer[2:0], x};
          count <= count + 1;
        end
    endcase
  end
end

endmodule