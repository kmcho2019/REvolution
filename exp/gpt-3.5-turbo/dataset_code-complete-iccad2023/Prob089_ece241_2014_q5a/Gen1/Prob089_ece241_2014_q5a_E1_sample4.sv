module TopModule (
  input clk,
  input areset,
  input x,
  output reg z
);

// Define states
parameter IDLE = 2'b00;
parameter ACCUMULATE = 2'b01;
parameter CONVERT = 2'b10;
parameter OUTPUT = 2'b11;

// Define state and next state signals
reg [1:0] state, next_state;

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
                next_state = ACCUMULATE;
            end
        end
        ACCUMULATE: begin
            if (x) begin
                result = result + 1;
            end
            next_state = CONVERT;
        end
        CONVERT: begin
            result = ~result + 1;
            next_state = OUTPUT;
        end
        OUTPUT: begin
            z = result;
            next_state = IDLE;
        end
    endcase
end

endmodule