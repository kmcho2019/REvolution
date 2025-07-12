module TopModule(
    input  in,
    input [1:0] state,
    output reg [1:0] next_state,
    output out
);

// Using always_comb for combinational logic to ensure optimization for performance
always_comb begin
    case(state)
        2'b00: next_state = in? 2'b01 : 2'b00; // State A
        2'b01: next_state = in? 2'b01 : 2'b10; // State B
        2'b10: next_state = in? 2'b11 : 2'b00; // State C
        2'b11: next_state = in? 2'b01 : 2'b10; // State D
        default: next_state = 2'b00; // Default state
    endcase
end

// Continuous assignment for output to minimize area and optimize for performance
assign out = (state == 2'b11); // Output is 1 only in state D

endmodule