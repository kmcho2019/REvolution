module TopModule(clk, reset, s, w, z);
  input clk;
  input reset;
  input s;
  input w;
  output z;

  reg [1:0] state;
  reg [1:0] count;

  parameter A = 2'b00;
  parameter B = 2'b01;
  parameter C = 2'b10;
  parameter D = 2'b11;

  always @(posedge clk) begin
    if (reset) begin
      state <= A;
      count <= 2'b00;
      z <= 1'b0;
    end else begin
      case (state)
        A: begin
          if (s) begin
            state <= B;
          end else begin
            state <= A;
          end
          count <= 2'b00;
          z <= 1'b0;
        end
        B: begin
          if (w) begin
            count <= count + 1;
          end
          state <= C;
        end
        C: begin
          if (w) begin
            count <= count + 1;
          end
          state <= D;
        end
        D: begin
          if (w) begin
            count <= count + 1;
          end
          if (count == 2) begin
            z <= 1'b1;
          end else begin
            z <= 1'b0;
          end
          state <= B;
          count <= 2'b00;
        end
      endcase
    end
  end
endmodule