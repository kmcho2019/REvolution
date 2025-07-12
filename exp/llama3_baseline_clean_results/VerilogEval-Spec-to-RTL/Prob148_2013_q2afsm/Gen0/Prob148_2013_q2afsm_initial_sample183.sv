module TopModule(
    input  clk,
    input  resetn,
    input  [2:0] r,
    output [2:0] g
);

reg [1:0] state; // state register
reg [1:0] next_state; // next state register

// Output signals assignment
assign g[0] = (state == 2'b01); // g0 is high when state is B
assign g[1] = (state == 2'b10); // g1 is high when state is C
assign g[2] = 1'b0; // g2 is always low since it's not represented in the state diagram

// State flip-flops
always @(posedge clk) begin
    if (~resetn) begin
        state <= 2'b00; // Reset to state A
    end else begin
        state <= next_state;
    end
end

// Next state logic
always @(*) begin
    case (state)
        2'b00: // State A
            if (r[0] == 1'b1) begin
                next_state = 2'b01; // Go to state B if r0 is high
            end else if (r[1] == 1'b1) begin
                next_state = 2'b10; // Go to state C if r1 is high
            end else if (r[2] == 1'b1) begin
                next_state = 2'b11; // Go to state D if r2 is high
            end else begin
                next_state = 2'b00; // Stay in state A if no requests
            end
        2'b01: // State B
            if (r[0] == 1'b1) begin
                next_state = 2'b01; // Stay in state B if r0 is high
            end else begin
                next_state = 2'b00; // Go to state A if r0 is low
            end
        2'b10: // State C
            if (r[1] == 1'b1) begin
                next_state = 2'b10; // Stay in state C if r1 is high
            end else begin
                next_state = 2'b00; // Go to state A if r1 is low
            end
        2'b11: // State D
            next_state = 2'b00; // This state is not actually reached due to the priority system
        default:
            next_state = 2'b00; // Default to state A
    endcase
end

endmodule