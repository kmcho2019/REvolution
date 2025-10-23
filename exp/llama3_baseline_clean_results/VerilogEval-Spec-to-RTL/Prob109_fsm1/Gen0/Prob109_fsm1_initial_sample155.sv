module TopModule(
    input clk,
    input areset,
    input in,
    output out
);

reg [0:0] state; // Current state
reg [0:0] next_state; // Next state

// State encoding
parameter A = 1'b0;
parameter B = 1'b1;

// Output is the current state
assign out = state;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= B; // Reset to state B
    end else begin
        case (state)
            A: begin
                if (~in) begin
                    state <= B;
                end else begin
                    state <= A;
                end
            end
            B: begin
                if (~in) begin
                    state <= A;
                end else begin
                    state <= B;
                end
            end
            default: begin
                state <= B; // Default to state B
            end
        endcase
    end
end

endmodule