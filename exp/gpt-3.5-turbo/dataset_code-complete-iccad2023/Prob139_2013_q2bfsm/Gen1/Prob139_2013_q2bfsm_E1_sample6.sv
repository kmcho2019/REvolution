module TopModule (
  input clk,
  input resetn,
  input x,
  input y,
  output reg f,
  output reg g
);

// State Definitions
parameter A = 1'b0;
parameter B = 1'b1;

// Define state register
reg state, next_state;

// Define state transition and output logic
always @(posedge clk or negedge resetn) begin
    if (~resetn) begin
        state <= A;
        f <= 0;
        g <= 0;
    end
    else begin
        state <= next_state;
        case (state)
            A: begin
                f <= 1;
                if (x == 1 && #1 x == 0 && #1 x == 1)
                    next_state <= B;
                else
                    next_state <= A;
            end
            B: begin
                f <= 0;
                if (y == 1 || (y == 0 && #1 y == 1))
                    g <= 1;
                else
                    g <= 0;
                next_state <= B;
            end
        endcase
    end
end

endmodule