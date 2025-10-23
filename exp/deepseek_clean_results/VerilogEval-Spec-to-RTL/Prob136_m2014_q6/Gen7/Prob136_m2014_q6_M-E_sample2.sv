module TopModule (
    input clk,
    input reset,
    input w,
    output z
);

// State encoding: [1] = output z, [0] = state bit
// A=00, B=01, C=10, D=11, E=10 (same as C but z=1), F=11 (same as D but z=1)
// Note: E and C share same encoding but different output (handled by MSB)
// F and D share same encoding but different output

reg [1:0] state;  // state[1] is output z

// Next state logic
wire [1:0] next_state;
assign next_state[1] = (state == 2'b00) ? 1'b0 :  // A
                      (state == 2'b01) ? (w ? 1'b1 : 1'b0) :  // B
                      (state == 2'b10) ? (w ? 1'b1 : 1'b1) :  // C/E
                      (state == 2'b11) ? (w ? 1'b0 : 1'b1) :  // D/F
                      1'b0;

assign next_state[0] = (state == 2'b00) ? w :  // A
                      (state == 2'b01) ? ~w :  // B
                      (state == 2'b10) ? w :    // C/E
                      (state == 2'b11) ? ~w :   // D/F
                      1'b0;

// State register
always @(posedge clk) begin
    if (reset)
        state <= 2'b00;  // A
    else
        state <= next_state;
end

// Output is directly the MSB of state
assign z = state[1];

endmodule