module TopModule (
    input clk,
    input areset,
    input in,
    output reg out
);

// Define the states of the state machine
reg [0:0] state; // 0 for A and 1 for B
reg [0:0] next_state;

// Define the state machine transitions
always @(*) begin
    case(state)
        1'b0: next_state = (in) ? 1'b0 : 1'b1;
        1'b1: next_state = (in) ? 1'b1 : 1'b0;
        default: next_state = 1'b0;
    endcase
end

// Define the output based on the state
always @(*) begin
    out = (state == 1'b1) ? 1'b1 : 1'b0;
end

// Update the state on the clock edge
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 1'b1;
    end else begin
        state <= next_state;
    end
end

endmodule