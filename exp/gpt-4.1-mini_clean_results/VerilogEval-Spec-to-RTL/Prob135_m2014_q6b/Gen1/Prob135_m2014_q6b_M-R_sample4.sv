module TopModule(
    input  [2:0] y,
    input  w,
    output reg Y1
);

    // Combinational block to compute next_y1 based on current state y and input w
    always @(*) begin
        case ({y, w})
            // Format: {y[2], y[1], y[0], w}
            4'b0000: Y1 = 1'b0; // A(000), w=0 -> B(001) y1=0
            4'b0001: Y1 = 1'b0; // A(000), w=1 -> A(000) y1=0

            4'b0010: Y1 = 1'b1; // B(001), w=0 -> C(010) y1=1
            4'b0011: Y1 = 1'b1; // B(001), w=1 -> D(011) y1=1

            4'b0100: Y1 = 1'b0; // C(010), w=0 -> E(100) y1=0
            4'b0101: Y1 = 1'b1; // C(010), w=1 -> D(011) y1=1

            4'b0110: Y1 = 1'b0; // D(011), w=0 -> F(101) y1=0
            4'b0111: Y1 = 1'b0; // D(011), w=1 -> A(000) y1=0

            4'b1000: Y1 = 1'b0; // E(100), w=0 -> E(100) y1=0
            4'b1001: Y1 = 1'b1; // E(100), w=1 -> D(011) y1=1

            4'b1010: Y1 = 1'b1; // F(101), w=0 -> C(010) y1=1
            4'b1011: Y1 = 1'b1; // F(101), w=1 -> D(011) y1=1

            default: Y1 = 1'b0; // For states beyond F (110,111), default to 0
        endcase
    end

endmodule