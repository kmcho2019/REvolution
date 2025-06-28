module TopModule (
  input clk,
  input resetn,
  input [3:1] r,
  output reg [3:1] g
);

// Define state codes
parameter A = 2'b00;
parameter B = 2'b01;
parameter C = 2'b10;
parameter D = 2'b11;

// Define state register
reg [1:0] state;

// Handle state logic and state flip-flops in one always block
always @(posedge clk or negedge resetn) begin
  if (~resetn) begin
    state <= A;
    g <= 3'b000; // Reset grants to 0
  end else begin
    case(state)
      A: begin
        if (r[1]) begin
          state <= B;
        end else if (r[2]) begin
          state <= C;
        end else if (r[3]) begin
          state <= D;
        end
      end
      B: begin
        if (r[1]) begin
          state <= B;
        end else begin
          state <= A;
        end
      end
      C: begin
        if (r[2]) begin
          state <= C;
        end else begin
          state <= A;
        end
      end
      D: begin
        if (r[1]) begin
          state <= D;
        end else if (r[2]) begin
          state <= D;
        end else if (r[3]) begin
          state <= D;
        end else begin
          state <= A;
        end
      end
    endcase
  end
end

// Set grant outputs after determining the next state
always @* begin
  case(state)
    B: g = 4'b0001;
    C: g = 4'b0010;
    D: g = 4'b0100;
    default: g = 4'b0000;
  endcase
end

endmodule