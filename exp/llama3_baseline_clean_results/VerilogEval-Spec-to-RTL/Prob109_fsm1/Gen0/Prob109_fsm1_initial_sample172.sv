module TopModule (
    input clk,
    input areset,
    input in,
    output out
);

reg [0:0] current_state; // Two-state encoding: A = 0, B = 1
reg [0:0] next_state;

always @(*) begin
    case (current_state)
        1'b0: begin // State A
            if (in == 1'b0) next_state = 1'b1; // Transition to B on in=0
            else next_state = 1'b0; // Stay in A on in=1
        end
        1'b1: begin // State B
            if (in == 1'b0) next_state = 1'b0; // Transition to A on in=0
            else next_state = 1'b1; // Stay in B on in=1
        end
        default: next_state = 1'b1; // Default to state B if current state is unknown
    endcase
end

always @(posedge clk or posedge areset) begin
    if (areset) begin
        current_state <= 1'b1; // Reset to state B
    end else begin
        current_state <= next_state;
    end
end

assign out = current_state; // Output is the current state

endmodule