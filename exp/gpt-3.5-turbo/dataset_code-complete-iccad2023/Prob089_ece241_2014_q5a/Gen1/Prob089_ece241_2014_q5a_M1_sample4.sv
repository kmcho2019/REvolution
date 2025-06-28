module TopModule (
  input clk,
  input areset,
  input x,
  output reg z
);

// Define states
parameter INIT = 2'b00;
parameter WAIT = 2'b01;
parameter ACCUMULATE = 2'b10;
parameter OUTPUT = 2'b11;

// Define state and next state signals
reg [1:0] state, next_state;

// Define internal signals
reg [7:0] result;

// State machine
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= INIT;
        result <= 8'h00;
    end
    else begin
        state <= next_state;
    end
end

// State transitions and logic
always @* begin
    case (state)
        INIT: begin
            if (areset) begin
                next_state = INIT;
            end
            else begin
                next_state = WAIT;
            end
        end
        WAIT: begin
            if (!areset) begin
                next_state = ACCUMULATE;
            end
            else begin
                next_state = WAIT;
            end
        end
        ACCUMULATE: begin
            result = result + x; // Add input x (2's complement) to the result
            next_state = OUTPUT;
        end
        OUTPUT: begin
            z = result;
            next_state = INIT;
        end
    endcase
end

endmodule