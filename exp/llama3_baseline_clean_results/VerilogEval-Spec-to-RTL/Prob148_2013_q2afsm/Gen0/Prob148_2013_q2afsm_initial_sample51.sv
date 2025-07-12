module TopModule(
    input clk,
    input resetn,
    input [2:0] r,
    output [2:0] g
);

reg [1:0] current_state;
reg [1:0] next_state;

// Continuous assignment for output g
assign g[0] = (current_state == 2'b01);
assign g[1] = (current_state == 2'b10);
assign g[2] = 1'b0; // Since there's no state where g2 is 1 based on the provided transitions

// State flip-flops
always @(posedge clk) begin
    if (!resetn) begin
        current_state <= 2'b00; // Reset to state A
    end else begin
        current_state <= next_state;
    end
end

// Next state logic
always @(*) begin
    case (current_state)
        2'b00: // State A
            if (r[0] == 1'b1) begin
                next_state = 2'b01; // State B
            end else if (r[1] == 1'b1) begin
                next_state = 2'b10; // State C
            end else if (r[2] == 1'b1) begin
                // No transition to D based on provided info, stay in A
                next_state = 2'b00;
            end else begin
                next_state = 2'b00; // Stay in A if no requests
            end
        2'b01: // State B
            if (r[0] == 1'b1) begin
                next_state = 2'b01; // Stay in B
            end else begin
                next_state = 2'b00; // Go back to A
            end
        2'b10: // State C
            if (r[1] == 1'b1) begin
                next_state = 2'b10; // Stay in C
            end else begin
                next_state = 2'b00; // Go back to A
            end
        default: // This should not happen, but just in case
            next_state = 2'b00;
    endcase
end

endmodule