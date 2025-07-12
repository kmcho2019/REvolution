module TopModule (
    input clk,
    input resetn,
    input [2:0] r,
    output [2:0] g
);

// State encoding: 00 - A, 01 - B, 10 - C
reg [1:0] current_state;
reg [1:0] next_state;

// State flip-flops
always @(posedge clk or negedge resetn) begin
    if (!resetn) begin
        current_state <= 2'b00; // Reset to state A
    end else begin
        current_state <= next_state;
    end
end

// State table
always @(*) begin
    case (current_state)
        2'b00: // State A
            if (r[0] == 1) begin
                next_state = 2'b01; // Go to state B if device 0 is requesting
            end else if (r[1] == 1) begin
                next_state = 2'b10; // Go to state C if device 1 is requesting
            end else if (r[2] == 1) begin
                next_state = 2'b00; // Go to state A if device 2 is requesting (no other requests)
            end else begin
                next_state = 2'b00; // Stay in state A if no requests
            end
        2'b01: // State B
            if (r[0] == 1) begin
                next_state = 2'b01; // Stay in state B if device 0 is still requesting
            end else begin
                next_state = 2'b00; // Go to state A if device 0 is not requesting
            end
        2'b10: // State C
            if (r[1] == 1) begin
                next_state = 2'b10; // Stay in state C if device 1 is still requesting
            end else begin
                next_state = 2'b00; // Go to state A if device 1 is not requesting
            end
        default: // This should not happen, but we need a default case
            next_state = 2'b00;
    endcase
end

// FSM outputs
assign g[0] = (current_state == 2'b01);
assign g[1] = (current_state == 2'b10);
assign g[2] = 1'b0; // g[2] is not used in this FSM

endmodule