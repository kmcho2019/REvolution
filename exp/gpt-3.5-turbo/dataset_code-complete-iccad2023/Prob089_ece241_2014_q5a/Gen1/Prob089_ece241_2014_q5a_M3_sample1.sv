module TopModule (
  input clk,
  input areset,
  input x,
  output reg z
);

// Define states
parameter INIT = 2'b00;
parameter ACCUMULATE = 2'b01;
parameter OUTPUT = 2'b10;

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
            if (!areset) begin
                next_state = ACCUMULATE;
            end
            else begin
                next_state = INIT;
            end
        end
        ACCUMULATE: begin
            next_state = OUTPUT;
            if (!x) begin
                result = result - 1;
            end
            else begin
                result = result + 1;
            end
        end
        OUTPUT: begin
            z = result;
            next_state = INIT;
        end
    endcase
end

endmodule