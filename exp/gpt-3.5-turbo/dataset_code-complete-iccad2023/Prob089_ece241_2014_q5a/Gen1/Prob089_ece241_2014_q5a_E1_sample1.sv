module TopModule (
  input clk,
  input areset,
  input x,
  output reg z
);

// Define states
parameter IDLE = 1'b0;
parameter PROCESS = 1'b1;

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
            if (areset) begin
                next_state = IDLE;
            end
            else begin
                next_state = PROCESS;
            end
        end
        PROCESS: begin
            if (x) begin
                result <= result + x;
            end
            z <= result;
            next_state = PROCESS; // Stay in PROCESS state for continuous accumulation
        end
    endcase
end

endmodule