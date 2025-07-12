module TopModule (
    input [2:0] y,
    input w,
    output Y1
);

    assign Y1 = y[1];

    // Next-state logic for y[1]
    reg next_y1;
    always @(*) begin
        case (y)
            3'b000: next_y1 = 0;  // A stays A or goes to B (y[1]=0)
            3'b001: next_y1 = w;  // B→C (w=0: y[1]=0), B→D (w=1: y[1]=1)
            3'b010: next_y1 = w;  // C→E (w=0: y[1]=0), C→D (w=1: y[1]=1)
            3'b011: next_y1 = !w; // D→A (w=1: y[1]=0), D→F (w=0: y[1]=1)
            3'b100: next_y1 = w;  // E→E (w=0: y[1]=0), E→D (w=1: y[1]=1)
            3'b101: next_y1 = w;  // F→C (w=0: y[1]=0), F→D (w=1: y[1]=1)
            default: next_y1 = 0; // Handle undefined states
        endcase
    end

endmodule