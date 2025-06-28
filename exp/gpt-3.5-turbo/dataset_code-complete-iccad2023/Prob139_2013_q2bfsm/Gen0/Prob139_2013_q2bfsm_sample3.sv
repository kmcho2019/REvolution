module TopModule (
  input clk,
  input resetn,
  input x,
  input y,
  output reg f,
  output reg g
);

// State Definitions
parameter A = 3'b000;
parameter B = 3'b001;
parameter C = 3'b010;

// Define state register
reg [2:0] state, next_state;

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
                next_state <= B;
            end
            B: begin
                if (x == 1 && #1 x == 0 && #1 x == 1)
                    next_state <= C;
                else
                    next_state <= B;                
            end
            C: begin
                if (y) begin
                    g <= 1;
                end
                else begin
                    g <= 0;
                end
                next_state <= C;
            end
        endcase
    end
end

endmodule