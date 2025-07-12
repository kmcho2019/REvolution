module TopModule(
    input clk,
    input areset,
    input in,
    output out
);

reg [0:0] state;  // Initialize state to 1 (B) after reset
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 1'b1;  // Reset to state B when areset is high
    end else begin
        case (state)
            1'b0: begin  // State A
                if (in == 1'b1) begin
                    state <= 1'b0;  // Stay in state A if in is 1
                end else begin
                    state <= 1'b1;  // Go to state B if in is 0
                end
            end
            1'b1: begin  // State B
                if (in == 1'b1) begin
                    state <= 1'b1;  // Stay in state B if in is 1
                end else begin
                    state <= 1'b0;  // Go to state A if in is 0
                end
            end
        endcase
    end
end

assign out = state;  // Output is the current state

endmodule