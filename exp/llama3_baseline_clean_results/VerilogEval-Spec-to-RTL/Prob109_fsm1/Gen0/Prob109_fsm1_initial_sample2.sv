module TopModule (
    input clk,
    input areset,
    input in,
    output out
);

reg [0:0] current_state; // Using 1 bit to represent the states (A = 0, B = 1)
reg [0:0] next_state;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        current_state <= 1; // Reset to state B
    end else begin
        current_state <= next_state;
    end
end

always @(*) begin
    case (current_state)
        1'b1: // State B
            begin
                if (in == 1'b0) begin
                    next_state = 1'b0; // Transition to A
                end else begin
                    next_state = 1'b1; // Stay in B
                end
            end
        1'b0: // State A
            begin
                if (in == 1'b0) begin
                    next_state = 1'b1; // Transition to B
                end else begin
                    next_state = 1'b0; // Stay in A
                end
            end
        default:
            next_state = 1'b1; // Default to B if current state is unknown
    endcase
end

assign out = current_state;

endmodule