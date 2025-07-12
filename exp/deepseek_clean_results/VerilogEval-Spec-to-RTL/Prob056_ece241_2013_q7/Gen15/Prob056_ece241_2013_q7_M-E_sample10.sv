module TopModule (
    input clk,
    input j,
    input k,
    output Q
);

// State definition
reg state;
localparam HOLD = 1'b0, TOGGLE = 1'b1;

always @(posedge clk) begin
    case ({j, k, state})
        3'b000: state <= HOLD;    // Hold state
        3'b001: state <= HOLD;    // Hold state
        3'b010: state <= HOLD;    // Reset to 0
        3'b011: state <= HOLD;    // Reset to 0
        3'b100: state <= TOGGLE;  // Set to 1
        3'b101: state <= TOGGLE;  // Set to 1
        3'b110: state <= TOGGLE;  // Toggle
        3'b111: state <= TOGGLE;  // Toggle
    endcase
end

// Output logic
assign Q = (state == TOGGLE) ? ~Q : 
           (j == 1'b1) ? 1'b1 : 
           (k == 1'b1) ? 1'b0 : Q;

endmodule