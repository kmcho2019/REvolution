module TopModule (
  input clk,
  input areset,
  input x,
  output reg z
);

// Define states
parameter IDLE = 2'b00;
parameter CONVERT = 2'b01;

// Define state and next state signals
reg [1:0] state, next_state;

// State machine
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= IDLE;
        z <= 1'b0;
    end
    else begin
        state <= next_state;
    end
end

// State transitions and output logic
always @* begin
    case (state)
        IDLE: begin
            if (x) begin
                next_state = CONVERT;
            end
            else begin
                next_state = IDLE;
            end
        end
        CONVERT: begin
            if (x) begin
                z <= ~z;
            end
            next_state = x ? CONVERT : IDLE;
        end
    endcase
end

endmodule