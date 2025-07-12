module TopModule(
    input clk,
    input resetn,
    input [2:0] r,
    output [2:0] g
);

// State codes (one-hot encoding)
reg [3:0] current_state;
reg [3:0] next_state;

// State flip-flops with clock gating
always @(posedge clk) begin
    if (~resetn) begin
        current_state <= 4'b0001;  // Reset to state A
    end else if (current_state!= next_state) begin
        current_state <= next_state;
    end
end

// State table
always @(*) begin
    case (current_state)
        4'b0001:  // State A
            if (r[0]) begin
                next_state = 4'b0010;  // Go to state B
            end else if (r[1]) begin
                next_state = 4'b0100;  // Go to state C
            end else if (r[2]) begin
                next_state = 4'b1000;  // Go to state D
            end else begin
                next_state = 4'b0001;  // Stay in state A
            end
        4'b0010:  // State B
            if (r[0]) begin
                next_state = 4'b0010;  // Stay in state B
            end else begin
                next_state = 4'b0001;  // Go back to state A
            end
        4'b0100:  // State C
            if (r[1]) begin
                next_state = 4'b0100;  // Stay in state C
            end else begin
                next_state = 4'b0001;  // Go back to state A
            end
        4'b1000:  // State D
            if (r[2]) begin
                next_state = 4'b1000;  // Stay in state D
            end else begin
                next_state = 4'b0001;  // Go back to state A
            end
        default:
            next_state = 4'b0001;  // Default to state A
    endcase
end

// Assign output signals g[0], g[1], and g[2] based on the current state
assign g[0] = current_state[1];  // State B
assign g[1] = current_state[2];  // State C
assign g[2] = current_state[3];  // State D

endmodule