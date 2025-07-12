module TopModule(
    input  wire a,
    input  wire b,
    input  wire sel_b1,
    input  wire sel_b2,
    output wire out_assign,
    output reg  out_always
);

    wire sel_combined;
    assign sel_combined = sel_b1 & sel_b2;

    // Continuous assignment mux: select b if sel_combined=1 else a
    assign out_assign = sel_combined ? b : a;

    // Procedural mux using case statement for variety and clarity
    always @(*) begin
        case (sel_combined)
            1'b1: out_always = b;
            default: out_always = a;
        endcase
    end

endmodule