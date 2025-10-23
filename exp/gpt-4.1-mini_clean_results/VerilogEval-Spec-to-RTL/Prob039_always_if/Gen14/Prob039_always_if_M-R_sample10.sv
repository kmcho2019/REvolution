module TopModule(
    input  a,
    input  b,
    input  sel_b1,
    input  sel_b2,
    output out_assign,
    output reg out_always
);

    wire sel_final;

    // Combine select inputs
    assign sel_final = sel_b1 & sel_b2;

    // Continuous assignment mux for out_assign
    assign out_assign = sel_final ? b : a;

    // Procedural mux with case statement for out_always
    always @(*) begin
        case(sel_final)
            1'b1: out_always = b;
            default: out_always = a;
        endcase
    end

endmodule