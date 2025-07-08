module TopModule(
    input clk,
    input rst_n,
    input [2:0] y,  // current state input (from flip-flops)
    input w,
    output Y1
);

    reg [2:0] y_reg;

    // Next state logic for y[1] only
    wire y1_next;
    // Extract current state bits
    wire y2 = y[2];
    wire y1 = y[1];
    wire y0 = y[0];

    // State encoding:
    // A=000, B=001, C=010, D=011, E=100, F=101

    // Compute y1_next according to the transition table above

    assign y1_next = 
        // A(000)
        (~y2 & ~y1 & ~y0 & ~w) ? 1'b0 :
        (~y2 & ~y1 & ~y0 &  w) ? 1'b0 :

        // B(001)
        (~y2 & ~y1 &  y0 & ~w) ? 1'b1 :
        (~y2 & ~y1 &  y0 &  w) ? 1'b1 :

        // C(010)
        (~y2 &  y1 & ~y0 & ~w) ? 1'b0 :
        (~y2 &  y1 & ~y0 &  w) ? 1'b1 :

        // D(011)
        (~y2 &  y1 &  y0 & ~w) ? 1'b0 :
        (~y2 &  y1 &  y0 &  w) ? 1'b0 :

        // E(100)
        ( y2 & ~y1 & ~y0 & ~w) ? 1'b0 :
        ( y2 & ~y1 & ~y0 &  w) ? 1'b1 :

        // F(101)
        ( y2 & ~y1 &  y0 & ~w) ? 1'b1 :
        ( y2 & ~y1 &  y0 &  w) ? 1'b1 :

        // Default
        1'b0;

    // For y[2] and y[0], hold constant
    wire y2_next = y2;
    wire y0_next = y0;

    // On clock, update state y_reg
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            y_reg <= 3'b000;  // reset to state A
        else
            y_reg <= {y2_next, y1_next, y0_next};
    end

    assign Y1 = y_reg[1];

endmodule