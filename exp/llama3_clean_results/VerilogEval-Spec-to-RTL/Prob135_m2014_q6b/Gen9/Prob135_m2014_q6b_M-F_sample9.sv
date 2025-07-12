module TopModule(
    input [2:0] y,
    input w,
    output reg Y1
);

always @(*) begin
    case (y)
        3'b000: // A
            Y1 = w? 0 : 0; // Next state is A when w=1, and A has y[1]=0
        3'b001: // B
            Y1 = w? 0 : 1; // Next state is D when w=1, and D has y[1]=1; Next state is C when w=0, and C has y[1]=0
        3'b010: // C
            Y1 = w? 1 : 1; // Next state is D when w=1, and D has y[1]=1; Next state is E when w=0, and E has y[1]=1
        3'b011: // D
            Y1 = w? 0 : 0; // Next state is A when w=1, and A has y[1]=0; Next state is F when w=0, and F has y[1]=0
        3'b100: // E
            Y1 = w? 1 : 1; // Next state is D when w=1, and D has y[1]=1; Next state is E when w=0, and E has y[1]=1
        3'b101: // F
            Y1 = w? 1 : 0; // Next state is D when w=1, and D has y[1]=1; Next state is C when w=0, and C has y[1]=0
        default:
            Y1 = 0; // Handling undefined states, assuming they should not occur
    endcase
end

endmodule