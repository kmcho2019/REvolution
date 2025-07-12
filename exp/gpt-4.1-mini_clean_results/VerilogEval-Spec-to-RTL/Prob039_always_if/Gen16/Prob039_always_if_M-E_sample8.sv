module TopModule(
    input  wire a,
    input  wire b,
    input  wire sel_b1,
    input  wire sel_b2,
    output wire out_assign,
    output reg  out_always
);

    wire sel1, sel2;
    reg  sel_comb;

    assign sel1 = sel_b1;
    assign sel2 = sel_b2;

    // Generate combined select signal via a case statement in always block
    always @(*) begin
        case ({sel1, sel2})
            2'b11: sel_comb = 1'b1;
            default: sel_comb = 1'b0;
        endcase
    end

    // Continuous assignment using the combined select
    assign out_assign = sel_comb ? b : a;

    // Procedural mux using case statement as well
    always @(*) begin
        case (sel_comb)
            1'b1: out_always = b;
            default: out_always = a;
        endcase
    end

endmodule