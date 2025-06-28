module TopModule (
  input clk,
  input reset,
  input s,
  input w,
  output reg z
);

  // Define states
  parameter A = 2'b00;
  parameter B = 2'b01;

  // State register
  reg [1:0] state, next_state;

  // Count of 'w' being 1 and 0
  reg [2:0] w1_count, w0_count;

  // State transition and output logic
  always @(posedge clk) begin
    if (reset) begin
      state <= A;
      w1_count <= 3'b0;
      w0_count <= 3'b0;
      z <= 0;
    end else begin
      state <= next_state;
      case(state)
        A: begin
             if (s == 1) begin
               next_state = B;
             end else begin
               next_state = A;
             end
           end
        B: begin
             if (w == 1) begin
               w1_count <= w1_count + 1;
             end else begin
               w0_count <= w0_count + 1;
             end
             if ((w1_count == 2) && (w0_count == 1)) begin
               z <= 1;
             end else begin
               z <= 0;
             end
             if ((w1_count + w0_count) == 3) begin
               w1_count <= 0;
               w0_count <= 0;
             end
             next_state = B;
           end
        default: next_state = A;
      endcase
    end
  end
endmodule