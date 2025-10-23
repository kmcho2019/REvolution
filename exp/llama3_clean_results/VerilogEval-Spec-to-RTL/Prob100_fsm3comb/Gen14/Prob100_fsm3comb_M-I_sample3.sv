module TopModule(
    input  in,
    input [1:0] state,
    output reg [1:0] next_state,
    output reg out
);

always @(*) begin
    case(state)
        2'b00: next_state = in ? 2'b01 : 2'b00;
        2'b01: next_state = 2'b01; // Simplified since next state is the same for in=0 and in=1
        2'b10: next_state = in ? 2'b11 : 2'b00;
        2'b11: next_state = in ? 2'b01 : 2'b10;
        default: next_state = 2'b00;
    endcase
end

assign out = state[1] && state[0]; // Simplified the output logic using bitwise AND

endmodule