module TopModule (
    input in,
    input [1:0] state,
    output reg [1:0] next_state,
    output out
);

// Output is high only when state is 2'b11 (D)
assign out = (state == 2'b11);  // Explicit comparison for power efficiency

// State transition logic
always @(*) begin
    case (state)
        2'b00: next_state = in ? 2'b01 : 2'b00;  // A
        2'b01: next_state = in ? 2'b01 : 2'b10;  // B
        2'b10: next_state = in ? 2'b11 : 2'b00;  // C
        2'b11: next_state = in ? 2'b01 : 2'b10;  // D
    endcase
end

endmodule