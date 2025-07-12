module TopModule (
    input  wire [2:0] y,   // current state bits y[2], y[1], y[0]
    input  wire       w,   // input
    output wire       Y1    // output equals current y[1]
);

    // next_y1 depends on current y and input w, defined via explicit case
    wire next_y1;

    // Concatenate y and w into 4-bit vector for case analysis
    wire [3:0] yw = {y, w};

    assign next_y1 = ( 
        (yw == 4'b0000) ? 1'b0 :  // A(000), w=0 -> B(001) y1=0
        (yw == 4'b0001) ? 1'b0 :  // A(000), w=1 -> A(000) y1=0
        (yw == 4'b0010) ? 1'b1 :  // B(001), w=0 -> C(010) y1=1
        (yw == 4'b0011) ? 1'b1 :  // B(001), w=1 -> D(011) y1=1
        (yw == 4'b0100) ? 1'b0 :  // C(010), w=0 -> E(100) y1=0
        (yw == 4'b0101) ? 1'b1 :  // C(010), w=1 -> D(011) y1=1
        (yw == 4'b0110) ? 1'b0 :  // D(011), w=0 -> F(101) y1=0
        (yw == 4'b0111) ? 1'b0 :  // D(011), w=1 -> A(000) y1=0
        (yw == 4'b1000) ? 1'b0 :  // E(100), w=0 -> E(100) y1=0
        (yw == 4'b1001) ? 1'b1 :  // E(100), w=1 -> D(011) y1=1
        (yw == 4'b1010) ? 1'b1 :  // F(101), w=0 -> C(010) y1=1
        (yw == 4'b1011) ? 1'b1 :  // F(101), w=1 -> D(011) y1=1
        1'b0 // default
    );

    assign Y1 = y[1];

endmodule