module TopModule(
    input  clk,
    input  areset,
    input  in,
    output out
);

reg [1:0] state; // 2-bit signal representing the current state using Gray code

// Current state update
always @(posedge clk or posedge areset) begin
    if (areset) begin // Asynchronous reset
        state <= 2'b01; // Reset to state B
    end else begin
        case(state)
            2'b00: state <= in ? 2'b00 : 2'b01; // State A
            2'b01: state <= in ? 2'b01 : 2'b00; // State B
            default: state <= 2'b01; // Default to state B
        endcase
    end
end

// Out is directly derived from the state in this implementation
assign out = state[0];

endmodule