module TopModule (
    input a,
    input b,
    input c,
    input d,
    output q
);

    wire [1:0] sel = {a, b};
    wire q_out;

    // 4-to-1 mux implementation
    assign q_out = (sel == 2'b00) ? ~(c | d) :
                   (sel == 2'b01) ? (c ^ d) :
                   (sel == 2'b10) ? (c ^ d) :
                   ~(c ^ d);

    assign q = q_out;

endmodule