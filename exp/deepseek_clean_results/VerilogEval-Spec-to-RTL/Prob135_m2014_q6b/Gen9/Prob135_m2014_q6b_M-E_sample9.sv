module TopModule (
    input [2:0] y,
    input w,
    output Y1
);

    assign Y1 = y[1];

    // Next-state logic for y[1] using bit pattern matching
    wire next_y1;
    assign next_y1 = 
        // State A (000): w=0->B(001)=0, w=1->A(000)=0
        ((y == 3'b000) & 1'b0) |
        // State B (001): w=0->C(010)=1, w=1->D(011)=1
        ((y == 3'b001) & w) |
        // State C (010): w=0->E(100)=0, w=1->D(011)=1
        ((y == 3'b010) & w) |
        // State D (011): w=0->F(101)=0, w=1->A(000)=0
        ((y == 3'b011) & 1'b0) |
        // State E (100): w=0->E(100)=0, w=1->D(011)=1
        ((y == 3'b100) & w) |
        // State F (101): w=0->C(010)=1, w=1->D(011)=1
        ((y == 3'b101) & 1'b1);

endmodule