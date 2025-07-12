module TopModule(
    input clk,
    input reset,
    input in,
    output out
);

reg [1:0] state; // Using 2 bits for state encoding (B=2'b00, A=2'b01)

always @(posedge clk) begin
    if (reset) begin
        state <= 2'b00; // Reset to state B
    end else begin
        case (state)
            2'b00: state <= in ? 2'b00 : 2'b01; // State B transitions
            2'b01: state <= in ? 2'b01 : 2'b00; // State A transitions
            default: state <= 2'b00; // Default to state B
        endcase
    end
end

assign out = state == 2'b00 ? 1'b1 : 1'b0; // Output based on state

endmodule