module TopModule (
  input clk,
  input areset,
  input x,
  output reg z
);

// Define states
parameter IDLE = 1'b0;
parameter ACCUMULATE = 1'b1;

// Define state and next state signals
reg state, next_state;

// Define internal signals
reg [7:0] result;

// State machine
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= IDLE;
        result <= 8'h00;
    end
    else begin
        state <= next_state;
    end
end

// State transitions and logic
always @* begin
    case (state)
        IDLE: begin
            if (!areset) begin
                next_state = ACCUMULATE;
            end
            else begin
                next_state = IDLE;
            end
        end
        ACCUMULATE: begin
            if (!x) begin
                result = result + 1;
            end
            next_state = (x) ? ACCUMULATE : IDLE;
        end
    endcase
end

// Assign output
always @(*) begin
    z = result;
end

endmodule