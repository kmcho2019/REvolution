module TopModule (
  input clk,
  input areset,
  input x,
  output reg z
);

// Define states
parameter ACCUMULATE = 1'b0;
parameter OUTPUT = 1'b1;

// Define state and next state signals
reg state, next_state;

// Define internal signals
reg [7:0] result;

// State machine
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= ACCUMULATE;
        result <= 8'h00;
    end
    else begin
        state <= next_state;
    end
end

// State transitions and logic
always @* begin
    case (state)
        ACCUMULATE: begin
            if (~areset) begin
                if (x) begin
                    result <= result - 1;
                end
                next_state <= OUTPUT;
            end
        end
        OUTPUT: begin
            z <= result;
            next_state <= ACCUMULATE;
        end
    endcase
end

endmodule