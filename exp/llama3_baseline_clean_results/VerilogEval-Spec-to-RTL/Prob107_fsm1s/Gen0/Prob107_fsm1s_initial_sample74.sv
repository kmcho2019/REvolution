module TopModule(
    input clk,
    input reset,
    input in,
    output out
);

// Define states
reg [0:0] state; // 1-bit state, '0' = A, '1' = B
reg [0:0] next_state;

// State register
always @(posedge clk) begin
    if (reset) begin
        state <= 1'b1; // Reset to state B
    end else begin
        state <= next_state;
    end
end

// Combinational logic for next state
always @(*) begin
    case (state)
        1'b0: // State A
            if (~in) begin
                next_state = 1'b1; // in = 0, go to B
            end else begin
                next_state = 1'b0; // in = 1, stay in A
            end
        1'b1: // State B
            if (~in) begin
                next_state = 1'b0; // in = 0, go to A
            end else begin
                next_state = 1'b1; // in = 1, stay in B
            end
        default:
            next_state = 1'b1; // Default to state B
    endcase
end

// Output logic
assign out = (state == 1'b1)? 1'b1 : 1'b0;

endmodule