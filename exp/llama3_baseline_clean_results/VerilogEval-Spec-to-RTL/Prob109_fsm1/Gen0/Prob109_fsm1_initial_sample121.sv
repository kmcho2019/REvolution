module TopModule(
    input clk,
    input areset,
    input in,
    output out
);

reg [0:0] current_state;

always @(*) begin
    if (areset) begin
        current_state <= 1'b1;  // Reset to state B
    end
end

always @(posedge clk) begin
    case (current_state)
        1'b0: begin  // State A
            if (in == 1'b0) begin
                current_state <= 1'b1;  // Transition to B
            end else begin
                current_state <= 1'b0;  // Stay in A
            end
        end
        1'b1: begin  // State B
            if (in == 1'b0) begin
                current_state <= 1'b0;  // Transition to A
            end else begin
                current_state <= 1'b1;  // Stay in B
            end
        end
    endcase
end

assign out = current_state;

endmodule