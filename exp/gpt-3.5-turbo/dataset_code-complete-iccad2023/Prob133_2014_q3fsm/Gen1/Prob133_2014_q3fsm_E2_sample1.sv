module TopModule (
  input clk,
  input reset,
  input s,
  input w,
  output reg z
);
  
  // Define states and counter
  reg [1:0] state;
  reg [2:0] w_count;
  parameter A = 2'b00;
  parameter B = 2'b01;
  
  // State register and counter
  always @(posedge clk or posedge reset) begin
    if (reset) begin
      state <= A;
      w_count <= 3'b0;
    end else begin
      case (state)
        A: begin
          if (s == 1) begin
            state <= B;
          end
        end
        B: begin
          if (w == 1) begin
            w_count <= w_count + 1;
          end
          if (w_count == 3) begin
            w_count <= 0;
            if (w == 1 || $past(w)) begin
              z <= 1;
            end else begin
              z <= 0;
            end
            state <= A;
          end
        end
      endcase
    end
  end
  
endmodule