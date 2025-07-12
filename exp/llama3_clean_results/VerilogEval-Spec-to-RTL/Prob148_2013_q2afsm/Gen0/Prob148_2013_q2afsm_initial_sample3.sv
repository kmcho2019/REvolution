module TopModule(
    input clk,
    input resetn,
    input [2:0] r,
    output [2:0] g
);

// State codes
reg [1:0] current_state;
reg [1:0] next_state;

// State flip-flops
always @(posedge clk) begin
    if (~resetn) begin
        current_state <= 2'b00;  // Reset to state A
    end else begin
        current_state <= next_state;
    end
end

// State table
always @(*) begin
    case (current_state)
        2'b00:  // State A
            if (r[0]) begin
                next_state = 2'b01;  // Go to state B
            end else if (r[1]) begin
                next_state = 2'b10;  // Go to state C
            end else if (r[2]) begin
                // Since device 2 has the lowest priority, it will only receive a grant if it is the only device making a request
                // This is already handled by the other conditions, so no need to explicitly check for r[2] here
                next_state = 2'b00;  // Stay in state A
            end else begin
                next_state = 2'b00;  // Stay in state A if no requests
            end
        2'b01:  // State B
            if (r[0]) begin
                next_state = 2'b01;  // Stay in state B
            end else begin
                next_state = 2'b00;  // Go back to state A
            end
        2'b10:  // State C
            if (r[1]) begin
                next_state = 2'b10;  // Stay in state C
            end else begin
                next_state = 2'b00;  // Go back to state A
            end
        default:
            next_state = 2'b00;  // Default to state A
    endcase
end

// Assign output signals g[0], g[1], and g[2] based on the current state
assign g[0] = (current_state == 2'b01);
assign g[1] = (current_state == 2'b10);
assign g[2] = 1'b0;  // g[2] is not used in this implementation

endmodule