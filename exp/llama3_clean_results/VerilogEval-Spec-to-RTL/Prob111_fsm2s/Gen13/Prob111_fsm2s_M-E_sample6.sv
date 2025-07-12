module TopModule (
    input  clk,
    input  reset,
    input  j,
    input  k,
    output reg out
);

reg [1:0] state; // Two-bit register for OFF (2'b00) and ON (2'b01) states

// Lookup table for next state
reg [1:0] next_state;

// Output logic
assign out = state[0]; // Directly assign state to output

// State register with synchronous reset
always_ff @(posedge clk) begin
    if (reset) begin
        state <= 2'b00; // Reset to OFF state
    end else begin
        case ({state, j, k})
            4'b0000: state <= 2'b00; // OFF with j=0 and k=0
            4'b0001: state <= 2'b00; // OFF with j=0 and k=1
            4'b0010: state <= 2'b01; // OFF with j=1 and k=0
            4'b0011: state <= 2'b01; // OFF with j=1 and k=1
            4'b0100: state <= 2'b01; // ON with j=0 and k=0
            4'b0101: state <= 2'b00; // ON with j=0 and k=1
            4'b0110: state <= 2'b01; // ON with j=1 and k=0
            4'b0111: state <= 2'b00; // ON with j=1 and k=1
            default: state <= 2'b00; // Reset to OFF for invalid states
        endcase
    end
end

endmodule