module TopModule (
    input clk,
    input x,
    input [2:0] y,
    output Y0,
    output z
);

    // State bit transition logic
    wire Y2_next = (y == 3'b100) ? (x ? 1'b1 : 1'b0) :  // State 100
                  (y == 3'b001 && x) ? 1'b1 :           // State 001 with x=1
                  1'b0;

    wire Y1_next = (y == 3'b100 && !x) ? 1'b1 :          // State 100 with x=0
                  (y == 3'b011 && x) ? 1'b1 :           // State 011 with x=1
                  1'b0;

    wire Y0_next = (y == 3'b000 && x) ? 1'b1 :          // State 000 with x=1
                  (y == 3'b001 && !x) ? 1'b1 :          // State 001 with x=0
                  (y == 3'b010 && x) ? 1'b1 :           // State 010 with x=1
                  (y == 3'b011 && !x) ? 1'b1 :          // State 011 with x=0
                  1'b0;

    // Output logic
    assign z = (y == 3'b011) || (y == 3'b100);

    // Next state outputs
    assign Y0 = Y0_next;

endmodule