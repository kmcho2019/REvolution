module TopModule (
  input clk,
  input resetn,
  input x,
  input y,
  output reg f,
  output reg g
);

// State Definitions
parameter A = 2'b00;
parameter B = 2'b01;
parameter C = 2'b10;

// Define state register
reg [1:0] state, next_state;

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
                if (x && (state == B || state == C))
                    next_state <= C;
                else
                    next_state <= B;                
            end
            C: begin
                if (y && (state == C || state == B))
                    g <= 1;
                else if (state == C && ~y)
                    g <= 0;
                next_state <= C;
            end
        endcase
    end
end

endmodule