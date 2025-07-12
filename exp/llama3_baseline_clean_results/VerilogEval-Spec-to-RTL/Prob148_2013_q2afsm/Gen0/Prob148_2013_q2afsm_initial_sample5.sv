module TopModule(
    input clk,
    input resetn,
    input [2:0] r,
    output [2:0] g
);

reg [1:0] state;  // Current state
reg [1:0] next_state;  // Next state

// Continuous assignment for FSM outputs
assign g[0] = (state == 2'b01);  // g0 is 1 in state B
assign g[1] = (state == 2'b10);  // g1 is 1 in state C
assign g[2] = 1'b0;  // g2 is always 0

// Next state logic
always @(*) begin
    case (state)
        2'b00:  // State A
            if (r[0] == 1'b1) begin
                next_state = 2'b01;  // If r0 is 1, go to state B
            end else if (r[1] == 1'b1) begin
                next_state = 2'b10;  // If r1 is 1, go to state C
            end else if (r[2] == 1'b1) begin
                next_state = 2'b00;  // If r2 is 1, stay in state A (D is not needed)
            end else begin
                next_state = 2'b00;  // If no requests, stay in state A
            end
        2'b01:  // State B
            if (r[0] == 1'b1) begin
                next_state = 2'b01;  // If r0 is 1, stay in state B
            end else begin
                next_state = 2'b00;  // If r0 is 0, go to state A
            end
        2'b10:  // State C
            if (r[1] == 1'b1) begin
                next_state = 2'b10;  // If r1 is 1, stay in state C
            end else begin
                next_state = 2'b00;  // If r1 is 0, go to state A
            end
        default:
            next_state = 2'b00;  // Default to state A
    endcase
end

// State flip-flops
always @(posedge clk or negedge resetn) begin
    if (~resetn) begin
        state <= 2'b00;  // Reset to state A
    end else begin
        state <= next_state;
    end
end

endmodule