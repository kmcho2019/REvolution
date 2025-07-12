module TopModule(
    input  clk,
    input  resetn,
    input  [2:0] r,
    output [2:0] g
);

reg [1:0] state;
reg [1:0] next_state;

// Output g based on the current state
assign g[0] = (state == 2'b01);
assign g[1] = (state == 2'b10);
assign g[2] = 1'b0; // Since state D is not actually used, g[2] is always 0

// Next state logic
always @(*) begin
    case (state)
        2'b00: // State A
            if (r[0])
                next_state = 2'b01; // Go to state B if r[0] = 1
            else if (r[1])
                next_state = 2'b10; // Go to state C if r[1] = 1 and r[0] = 0
            else if (r[2])
                next_state = 2'b11; // Go to state D if r[2] = 1 and r[0] = 0 and r[1] = 0
            else
                next_state = 2'b00; // Stay in state A if no requests
        2'b01: // State B
            if (r[0])
                next_state = 2'b01; // Stay in state B if r[0] = 1
            else
                next_state = 2'b00; // Go back to state A if r[0] = 0
        2'b10: // State C
            if (r[1])
                next_state = 2'b10; // Stay in state C if r[1] = 1
            else
                next_state = 2'b00; // Go back to state A if r[1] = 0
        2'b11: // State D
            if (r[2])
                next_state = 2'b11; // Stay in state D if r[2] = 1
            else
                next_state = 2'b00; // Go back to state A if r[2] = 0
        default:
            next_state = 2'b00; // Default to state A
    endcase
end

// State flip-flops
always @(posedge clk or negedge resetn) begin
    if (~resetn) begin
        state <= 2'b00; // Synchronous reset to state A
    end else begin
        state <= next_state;
    end
end

endmodule