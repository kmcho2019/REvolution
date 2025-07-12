module TopModule(
    input  wire a,
    input  wire b,
    input  wire sel_b1,
    input  wire sel_b2,
    output wire out_assign,
    output reg  out_always
);

    wire sel_final;

    assign sel_final = sel_b1 & sel_b2;

    // Continuous assignment using ternary operator for mux
    assign out_assign = sel_final ? b : a;

    // Procedural mux using case statement on sel_final
    always @* begin
        case (sel_final)
            1'b1: out_always = b;
            1'b0: out_always = a;
            default: out_always = 1'bx; // Defensive coding
        endcase
    end

endmodule