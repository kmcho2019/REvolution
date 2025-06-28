module TopModule (
  input clk,
  input resetn,
  input [3:1] r,
  output reg [3:1] g
);

  // Define state codes
  localparam A = 2'b00;
  localparam B = 2'b01;
  localparam C = 2'b10;
  localparam D = 2'b11;

  reg [1:0] state, next_state;

  // State flip-flop
  always @(posedge clk or negedge resetn) begin
    if (~resetn)
      state <= A;
    else
      state <= next_state;
  end

  // State table logic
  always @* begin
    next_state = state;
    g = 4'b000; // Initialize grants to 0

    case (state)
      A: begin
        if (r[1]) begin
          next_state = B;
          g[1] = 1;
        end
        else if (r[2]) begin
          next_state = C;
          g[2] = 1;
        end
        else if (r[3]) begin
          next_state = D;
          g[3] = 1;
        end
      end
      B: begin
        if (r[1]) begin
          next_state = B;
          g[1] = 1;
        end
        else
          next_state = A;
      end
      C: begin
        if (r[2]) begin
          next_state = C;
          g[2] = 1;
        end
        else
          next_state = A;
      end
      D: begin
        next_state = D;
      end
    endcase
  end

endmodule