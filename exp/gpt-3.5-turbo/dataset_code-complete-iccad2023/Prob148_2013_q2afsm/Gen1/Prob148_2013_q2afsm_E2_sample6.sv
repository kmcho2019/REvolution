module TopModule (
  input clk,
  input resetn,
  input [3:1] r,
  output reg [3:1] g
);

  // State declaration
  reg [1:0] state, next_state;
  parameter A = 2'b00, B = 2'b01, C = 2'b10, D = 2'b11;

  // State transition logic
  always @(posedge clk, negedge resetn) begin
    if (!resetn) begin
      state <= A;
    end else begin
      state <= next_state;
    end
  end

  // Output and next-state logic
  always @(*) begin
    case(state)
      A: begin
        if (r[1]) begin
          g = {1'b1, 1'b0, 1'b0};
          next_state = B;
        end else if (r[2]) begin
          g = {1'b0, 1'b1, 1'b0};
          next_state = C;
        else if (r[3]) begin
          g = {1'b0, 1'b0, 1'b1};
          next_state = A;  // Stay in state A if only device 3 requested
        else begin
          g = {1'b0, 1'b0, 1'b0};
          next_state = A;
        end
      end

      B: begin
        if (r[1]) begin
          g = {1'b1, 1'b0, 1'b0};
          next_state = B;
        end else begin
          g = {1'b0, 1'b0, 1'b0};
          next_state = A;
        end
      end

      C: begin
        if (r[2]) begin
          g = {1'b0, 1'b1, 1'b0};
          next_state = C;
        end else begin
          g = {1'b0, 1'b0, 1'b0};
          next_state = A;
        end
      end

      D: begin
        if (r[3]) begin
          g = {1'b0, 1'b0, 1'b1};
          next_state = D;
        else begin
          g = {1'b0, 1'b0, 1'b0};
          next_state = A;
        end
      end
    endcase
  end

endmodule