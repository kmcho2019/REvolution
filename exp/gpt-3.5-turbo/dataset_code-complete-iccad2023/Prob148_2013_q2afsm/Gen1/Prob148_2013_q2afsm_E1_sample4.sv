module TopModule (
  input clk,
  input resetn,
  input [3:1] r,
  output reg [3:1] g
);

  // Define state codes
  localparam IDLE = 3'b000;
  localparam A = 3'b001;
  localparam B = 3'b010;
  localparam C = 3'b011;
  localparam D = 3'b100;

  reg [2:0] state;

  // State and grant logic
  always @(posedge clk or negedge resetn) begin
    if (~resetn) begin
      state <= IDLE;
      g <= 3'b000;
    end else begin
      case (state)
        IDLE: begin
          if (r[1] && !r[2] && !r[3])
            state <= A;
        end
        A: begin
          if (r[1])
            state <= B;
          else if(r[2])
            state <= C;
          else if(r[3])
            state <= D;
        end
        B: begin
          if (r[1])
            state <= B;
          else
            state <= A;
        end
        C: begin
          if (r[2])
            state <= C;
          else
            state <= A;
        end
        D: begin
          state <= D;
        end
      endcase

      // Grant outputs based on state
      case (state)
        IDLE: g <= 3'b000;
        A: g <= 3'b000;
        B: g <= 3'b010;
        C: g <= 3'b100;
        D: g <= 3'b100;
      endcase
    end
  end

endmodule