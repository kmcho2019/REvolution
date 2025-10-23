module TopModule(
    input clk,
    input resetn,
    input [2:0] r,
    output [2:0] g
);

reg [1:0] current_state;
reg [1:0] next_state;

// Continuous assignment for outputs
assign g[0] = (current_state == 2'b01); // Grant for device 0 when in state B
assign g[1] = (current_state == 2'b10); // Grant for device 1 when in state C
assign g[2] = 1'b0; // Since there's no explicit granting state for device 2 in the transitions

// State flip-flops
always @(posedge clk) begin
    if (~resetn) begin
        current_state <= 2'b00; // Reset to state A
    end else begin
        current_state <= next_state;
    end
end

// State table
always @(*) begin
    case (current_state)
        2'b00: begin // State A
            if (r[0] == 1'b1) begin
                next_state = 2'b01; // Transition to state B if r0 is high
            end else if (r[1] == 1'b1) begin
                next_state = 2'b10; // Transition to state C if r1 is high (and r0 is low)
            end else begin
                next_state = 2'b00; // Stay in state A if no requests
            end
        end
        2'b01: begin // State B
            if (r[0] == 1'b1) begin
                next_state = 2'b01; // Stay in state B if device 0's request is still high
            end else begin
                next_state = 2'b00; // Go back to state A if device 0's request is low
            end
        end
        2'b10: begin // State C
            if (r[1] == 1'b1) begin
                next_state = 2'b10; // Stay in state C if device 1's request is still high
            end else begin
                next_state = 2'b00; // Go back to state A if device 1's request is low
            end
        end
        default: begin
            next_state = 2'b00; // Default to state A for any other state
        end
    endcase
end

endmodule