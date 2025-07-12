module TopModule (
    input [2:0] y,
    input w,
    output Y1
);

assign Y1 = y[1];  // Direct output assignment

wire y1_next;

always @(*) begin
    case (y)
        3'b000: y1_next = 0;  // State A -> stays 0 or goes to B (001)
        3'b001: y1_next = w;  // State B -> C (010) when w=0, D (011) when w=1
        3'b010: y1_next = w;  // State C -> E (100) when w=0, D (011) when w=1
        3'b011: y1_next = ~w; // State D -> F (101) when w=0, A (000) when w=1
        3'b100: y1_next = w ? 1 : y[1]; // State E -> D when w=1, maintain when w=0
        3'b101: y1_next = 1;  // State F -> C (010) or D (011), both have y[1]=1
        default: y1_next = 0;
    endcase
end

endmodule