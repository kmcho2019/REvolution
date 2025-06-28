module TopModule (
  input clk,
  input areset,
  input x,
  output reg [7:0] z
);

// Define states
parameter INIT = 2'b00;
parameter ACCUMULATE = 2'b01;
parameter OUTPUT = 2'b10;

// Define state and next state signals
reg [1:0] state, next_state;

// State machine
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= INIT;
        z <= 8'b0;
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
                next_state = ACCUMULATE;
            end
        end
        ACCUMULATE: begin
            if (!x) begin
                next_state = OUTPUT;
            end
            else begin
                z <= {~z[0], z[7:1]};  // Toggle all bits for 2's complement
                next_state = ACCUMULATE;
            end
        end
        OUTPUT: begin
            z <= z;  // Output 2's complement
            next_state = INIT;
        end
    endcase
end

endmodule