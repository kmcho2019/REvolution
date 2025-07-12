module TopModule (
    input  wire [2:0] y,
    input  wire       w,
    output wire       Y1
);

    wire term_B;
    wire term_Cw;
    wire term_EF;

    // term_B corresponds to state B condition: ~y2 & ~y1 & y0
    assign term_B = (~y[2]) & (~y[1]) & (y[0]);

    // term_Cw corresponds to state C & w: ~y2 & y1 & ~y0 & w
    assign term_Cw = (~y[2]) & (y[1]) & (~y[0]) & w;

    // term_EF corresponds to states E or F condition: y2 & ~y1 & (y0 | w)
    assign term_EF = (y[2]) & (~y[1]) & (y[0] | w);

    wire next_y1;

    always @(*) begin
        next_y1 = term_B | term_Cw | term_EF;
    end

    // Output is the current y[1]
    assign Y1 = y[1];

endmodule