module TopModule (
  input clk,
  input reset,
  input s,
  input w,
  output reg z
);

// Define the states
typedef enum logic [1:0] {
  State_A
} state_t;

// Define the state variable
reg [1:0] state;
reg [1:0] w_count;

always @(posedge clk) begin
  if (reset) begin
    state <= State_A;
    z <= 0;
    w_count <= 0;
  end else begin
    case(state)
      State_A: begin
        if (w == 1) begin
          w_count <= w_count + 1;
        end else begin
          w_count <= 0;
        end

        if (w_count == 2) begin
          z <= 1;
        end else begin
          z <= 0;
        end
      end
    endcase
  end
end

endmodule