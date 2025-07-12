module TopModule (
    input [2:0] y,
    input w,
    output Y1
);

// Next-state logic for y[1]
reg y1_next;
always @(*) begin
    case (y)
        3'b000: y1_next = 1'b0;  // A -> A/B: y[1] stays 0
        3'b001: y1_next = 1'b1;  // B -> C/D: y[1] becomes 1
        3'b010: y1_next = 1'b1;  // C -> D/E: y[1] stays 1
        3'b011: y1_next = ~w;    // D -> A(w=1)/F(w=0): y[1] = 0 if w, else 1
        3'b100: y1_next = 1'b1;  // E -> D/E: y[1] stays 1
        3'b101: y1_next = w;     // F -> C(w=0)/D(w=1): y[1] = w
        default: y1_next = 1'b0;
    endcase
end

assign Y1 = y[1];

endmodule