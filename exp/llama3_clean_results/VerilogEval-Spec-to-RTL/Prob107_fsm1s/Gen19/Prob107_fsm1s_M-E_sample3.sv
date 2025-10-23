module TopModule(
    input clk,
    input reset,
    input in,
    output reg out
);

reg [1:0] state; // State variable, using 2 bits for simplicity

always @(posedge clk) begin
    if(reset) begin
        state <= 2'b10; // Reset to state B (out=1)
    end else begin
        case(state)
            2'b10: state <= (in) ? 2'b10 : 2'b00; // From B
            2'b00: state <= (in) ? 2'b00 : 2'b10; // From A
            default: state <= 2'b10; // Default to state B
        endcase
    end
end

assign out = (state == 2'b10) ? 1'b1 : 1'b0; // Output based on state

endmodule