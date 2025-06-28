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

// Define x input counters
reg [2:0] x_counter;
reg x_pattern_detected;

// Define y input counter
reg [1:0] y_counter;

// State Transition and Output Logic
always @(posedge clk or negedge resetn) begin
    if (~resetn) begin
        state <= A;
        f <= 0;
        g <= 0;
        x_counter <= 0;
        y_counter <= 0;
        x_pattern_detected <= 0;
    end
    else begin
        state <= next_state;
        case (state)
            A: begin
                f <= 1;
                if (x == 1 && x_counter == 2)
                    x_pattern_detected <= 1;
                if (x_pattern_detected && y == 1)
                    g <= 1;
                else if (x_pattern_detected && y_counter < 2)
                    y_counter <= y_counter + 1;
                else
                    g <= 0;
                if (x == 1)
                    x_counter <= x_counter + 1;
                else
                    x_counter <= 0;
                if (x_pattern_detected && y == 1)
                    next_state <= B;
                else
                    next_state <= A;
            end
            B: begin
                g <= 1;
                if (y != 1)
                    g <= 0;
                next_state <= B;
            end
        endcase
    end
end

endmodule