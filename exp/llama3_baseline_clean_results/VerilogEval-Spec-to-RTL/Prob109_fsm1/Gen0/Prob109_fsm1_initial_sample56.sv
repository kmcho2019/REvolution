module TopModule(
    input clk,
    input areset,
    input in,
    output out
);

reg [0:0] state;
reg [0:0] next_state;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 1;  // Reset to state B
    end else begin
        case (state)
            1'b0: begin  // State A
                if (in) begin
                    state <= 1'b0;  // Stay in state A if input is 1
                end else begin
                    state <= 1'b1;  // Go to state B if input is 0
                end
            end
            1'b1: begin  // State B
                if (in) begin
                    state <= 1'b1;  // Stay in state B if input is 1
                end else begin
                    state <= 1'b0;  // Go to state A if input is 0
                end
            end
        endcase
    end
end

assign out = state;  // Drive the output with the current state

endmodule