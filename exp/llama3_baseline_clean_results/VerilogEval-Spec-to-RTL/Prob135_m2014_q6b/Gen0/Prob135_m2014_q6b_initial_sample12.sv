module TopModule(
    input [2:0] y,
    input w,
    output Y1
);

reg Y1_next;

always @(*)
begin
    case(y)
        3'b000: // State A
            Y1_next = w;
        3'b001: // State B
            Y1_next = ~w;
        3'b010: // State C
            Y1_next = ~w;
        3'b011: // State D
            Y1_next = w;
        3'b100: // State E
            Y1_next = ~w;
        3'b101: // State F
            Y1_next = w;
        default: 
            Y1_next = 1'b0;
    endcase
end

assign Y1 = Y1_next;

endmodule