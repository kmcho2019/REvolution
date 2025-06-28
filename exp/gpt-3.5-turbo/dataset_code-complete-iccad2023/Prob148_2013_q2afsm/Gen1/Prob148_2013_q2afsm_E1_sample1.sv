module TopModule (
  input clk,
  input resetn,
  input [3:1] r,
  output reg [3:1] g
);

  // Declare state signals
  reg [2:0] state, next_state;
  // State encoding
 parameter A = 3'b000, B = 3'b001, C = 3'b010, D = 3'b011, E = 3'b100;

  // State transition and logic
  always @(posedge clk or negedge resetn) begin
    if (~resetn) begin
      state <= A;
    end else begin
      state <= next_state;
    end
  end

  // State logic based on the state diagram
  always @(*) begin
    case(state)
      A: begin
        if (r[1]) next_state = B;
        else if (r[2]) next_state = C;
        else if (r[3]) next_state = D;
        else next_state = A;
      end
      B: begin
        if (r[1]) next_state = B;
        else if (r[2]) next_state = C;
        else if (r[3]) next_state = D;
        else next_state = A;
      end
      C: begin
        if (r[2]) next_state = C;
        else if (r[3]) next_state = D;
        else next_state = A;
      end
      D: begin
        if (r[3]) next_state = D;
        else next_state = A;
      end
      default: next_state = A;
    endcase
  end

  // Output assignment based on state
  always @(*) begin
    case(state)
      A: g = {1'b0, 1'b0, 1'b0};
      B: g = {1'b1, 1'b0, 1'b0};
      C: g = {1'b0, 1'b1, 1'b0};
      D: g = {1'b0, 1'b0, 1'b1};
      E: g = g; // Maintain previous grant outputs in state E
    endcase
  end

endmodule