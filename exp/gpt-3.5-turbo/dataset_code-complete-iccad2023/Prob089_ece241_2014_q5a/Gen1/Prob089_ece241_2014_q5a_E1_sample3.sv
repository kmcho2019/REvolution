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

// Local variables
reg [7:0] twosComplement;

// State machine
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= IDLE;
        twosComplement <= 8'h00;
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
                next_state = PROCESS;
            end
            else begin
                next_state = IDLE;
            end
        end
        
        PROCESS: begin
            twosComplement = ~x + 1; // 2's complement calculation: invert bits and add 1
            next_state = IDLE;
        end
    endcase
end

// Output assignment
always @* begin
    if (state == PROCESS) begin
        z = twosComplement;
    end
    else begin
        z = 1'b0; // Output 0 when not in PROCESS state
    end
end

endmodule