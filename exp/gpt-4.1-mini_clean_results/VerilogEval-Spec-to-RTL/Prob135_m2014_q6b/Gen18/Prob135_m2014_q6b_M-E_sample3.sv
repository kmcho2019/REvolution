module TopModule (
    input  wire [2:0] y,
    input  wire       w,
    output reg        Y1
);

    always @(*) begin
        case (y)
            3'b000: Y1 = 1'b0;             // A(000) next states: A or B, both y[1]=0
            3'b001: Y1 = (w) ? 1'b1 : 1'b0; // B(001): w=0->C(010,y[1]=1), w=1->D(011,y[1]=1)
            3'b010: Y1 = 1'b1;             // C(010): next states E(100,y[1]=0) or D(011,y[1]=1), but from transitions both y[1] in next state is 1 or 0? Check transitions:
                                          // C(0) --0--> E(100) y[1]=0, C(0) --1--> D(011) y[1]=1, so depends on w=0 or 1, but w is not input here, it's next-state determined by input w or not? Actually w is a separate input.
                                          // But from problem statement, the input w influences some transitions, but C transitions are w=0:0->E or 0->D?
                                          // No, from problem the w input is used to determine next state generally. In transitions, w affects all transitions, so I will take w into account:
                                          // For C:
                                          // C(0) --0--> E
                                          // C(0) --1--> D
                                          // So input at transition is 0 or 1, meaning w. So w=0->E(100,y[1]=0), w=1->D(011,y[1]=1)
                                          // So next y[1] = w ? 1 : 0
        endcase
    end

endmodule