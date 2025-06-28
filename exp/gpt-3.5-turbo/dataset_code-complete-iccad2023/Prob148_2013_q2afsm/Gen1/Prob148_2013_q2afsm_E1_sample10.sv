module TopModule (
  input clk,
  input resetn,
  input [3:1] r,
  output reg [3:1] g
);

  // State encoding
  parameter A = 2'b00, B = 2'b01, C = 2'b10, D = 2'b11;
  
  // Declare state signals
  reg [1:0] state, next_state;

  // State transition and output logic
  always @* begin
    case (state)
      A: begin
        if (r[1]) begin
          next_state = B;
          g = {1,0,0};
        end
        else if (r[2]) begin
          next_state = C;
          g = {0,1,0};
        end
        else if (r[3]) begin
          next_state = D;
          g = {0,0,1};
        end
        else begin
          next_state = A;
          g = {0,0,0};
        end
      end
      
      B: begin
        if (r[1]) begin
          next_state = B;
          g = {1,0,0};
        end
        else begin
          next_state = A;
          g = {0,0,0};
        end
      end
      
      C: begin
        if (r[2]) begin
          next_state = C;
          g = {0,1,0};
        end
        else begin
          next_state = A;
          g = {0,0,0};
        end
      end
      
      D: begin
        if (r[3]) begin
          next_state = D;
          g = {0,0,1};
        end
        else begin
          next_state = A;
          g = {0,0,0};
        end
      end
    endcase
  end

  // State flip-flops
  always @(posedge clk or negedge resetn) begin
    if (~resetn) begin
      state <= A;
    end
    else begin
      state <= next_state;
    end
  end

endmodule