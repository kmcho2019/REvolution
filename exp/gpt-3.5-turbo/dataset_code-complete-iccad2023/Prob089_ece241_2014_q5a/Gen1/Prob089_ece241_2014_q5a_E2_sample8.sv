module TopModule (
  input clk,
  input areset,
  input x,
  output reg z
);

// Define states
parameter IDLE = 2'b00;
parameter ACCUMULATE = 2'b01;
parameter OUTPUT = 2'b10;

// Define state and next state signals
reg [1:0] state, next_state;

// Define accumulator for 2's complement conversion
reg [7:0] accumulator;

// State machine
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= IDLE;
        accumulator <= 0;
        z <= 0;
    end
    else begin
        state <= next_state;
    end
end

// State transitions and logic
always @* begin
    case (state)
        IDLE: begin
            if (~areset) begin
                next_state = ACCUMULATE;
            end
            else begin
                next_state = IDLE;
            end
        end
        ACCUMULATE: begin
            accumulator <= accumulator - x; // 2's complement conversion
            next_state = OUTPUT;
        end
        OUTPUT: begin
            z <= accumulator;
            next_state = IDLE;
        end
    endcase
end

endmodule