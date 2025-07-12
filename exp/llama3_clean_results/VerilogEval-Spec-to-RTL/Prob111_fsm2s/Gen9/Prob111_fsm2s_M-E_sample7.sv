module TopModule (
    input  clk,
    input  reset,
    input  j,
    input  k,
    output reg out
);

reg [1:0] state; // Two-bit state register (OFF=2'b00, ON=2'b01)
reg [1:0] nextState; // Next state register

// LUT for next state
always_comb begin
    case ({state, j, k})
        4'b0000: nextState = 2'b00; // OFF, j=0, k=0
        4'b0001: nextState = 2'b00; // OFF, j=0, k=1
        4'b0010: nextState = 2'b01; // OFF, j=1, k=0
        4'b0011: nextState = 2'b01; // OFF, j=1, k=1
        4'b0100: nextState = 2'b01; // ON, j=0, k=0
        4'b0101: nextState = 2'b00; // ON, j=0, k=1
        4'b0110: nextState = 2'b01; // ON, j=1, k=0
        4'b0111: nextState = 2'b00; // ON, j=1, k=1
        default: nextState = 2'b00; // Default to OFF state
    endcase
end

// State register with synchronous reset
always_ff @(posedge clk) begin
    if (reset) begin
        state <= 2'b00; // Reset to OFF state
    end else begin
        state <= nextState;
    end
end

// Output logic (LUT or direct assignment)
assign out = (state == 2'b01) ? 1'b1 : 1'b0; // Output is 1 when state is ON

endmodule