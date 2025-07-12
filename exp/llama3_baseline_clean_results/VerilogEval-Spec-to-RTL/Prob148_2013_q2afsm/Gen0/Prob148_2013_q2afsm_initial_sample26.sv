module TopModule(
    input  clk,
    input  resetn,
    input  [2:0] r,
    output [2:0] g
);

// State encoding: A = 2'b00, B = 2'b01, C = 2'b10, D = 2'b11
reg [1:0] current_state;
reg [1:0] next_state;

// Continuous assignment for output signals g
assign g[0] = (current_state == 2'b01);
assign g[1] = (current_state == 2'b10);
assign g[2] = 0; // Since state D is not actually used

// State flip-flops
always @(posedge clk) begin
    if (!resetn) begin
        current_state <= 2'b00; // Reset to state A
    end else begin
        current_state <= next_state;
    end
end

// State table (next state logic)
always @(*) begin
    case (current_state)
        2'b00: // State A
            if (r[0]) begin
                next_state = 2'b01; // Priority to device 0
            end else if (r[1]) begin
                next_state = 2'b10; // Priority to device 1
            end else if (r[2]) begin
                next_state = 2'b11; // Lowest priority to device 2
            end else begin
                next_state = 2'b00; // Stay in state A if no requests
            end
        2'b01: // State B
            if (r[0]) begin
                next_state = 2'b01; // Stay in state B if device 0 still requesting
            end else begin
                next_state = 2'b00; // Go back to state A if device 0 is done
            end
        2'b10: // State C
            if (r[1]) begin
                next_state = 2'b10; // Stay in state C if device 1 still requesting
            end else begin
                next_state = 2'b00; // Go back to state A if device 1 is done
            end
        2'b11: // State D (not actually used)
            next_state = 2'b00; // Not actually used, but needed for the case statement
        default: next_state = 2'b00;
    endcase
end

endmodule