module TopModule (
  input clk,
  input areset,
  input x,
  output reg z
);

// Define states
parameter WAIT = 2'b00;
parameter ACCUMULATE = 2'b01;
parameter OUTPUT = 2'b10;

// Define state and next state signals
reg [1:0] state, next_state;

// Define internal signals
reg [7:0] result;
reg [7:0] accum;

// State machine
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= WAIT;
        result <= 8'h00;
        accum <= 8'h00;
    end
    else begin
        state <= next_state;
    end
end

// State transitions and logic
always @* begin
    case (state)
        WAIT: begin
            if (areset) begin
                next_state = WAIT;
            end
            else begin
                next_state = ACCUMULATE;
            end
        end
        ACCUMULATE: begin
            accum <= accum + (x ? -1 : 1);
            next_state = OUTPUT;
        end
        OUTPUT: begin
            z = accum;
            next_state = WAIT;
        end
    endcase
end

endmodule