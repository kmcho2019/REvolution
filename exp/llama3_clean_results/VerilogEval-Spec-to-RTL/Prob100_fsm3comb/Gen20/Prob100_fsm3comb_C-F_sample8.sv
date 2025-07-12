module NextStateLogic(
    input  in,
    input [1:0] state,
    output reg [1:0] next_state
);

always @(*) begin
    case(state)
        2'b00: next_state = in? 2'b01 : 2'b00; // State A
        2'b01: next_state = in? 2'b01 : 2'b10; // State B
        2'b10: next_state = in? 2'b11 : 2'b00; // State C
        2'b11: next_state = in? 2'b01 : 2'b10; // State D
        default: next_state = 2'b00; // Default state
    endcase
end

endmodule

module OutputLogic(
    input [1:0] state,
    output reg out
);

assign out = (state == 2'b11); // Output is 1 only in state D

endmodule

module TopModule(
    input  in,
    input [1:0] state,
    output reg [1:0] next_state,
    output reg out
);

NextStateLogic ns_logic(
   .in(in),
   .state(state),
   .next_state(next_state)
);

OutputLogic o_logic(
   .state(state),
   .out(out)
);

endmodule