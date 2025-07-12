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

    // Continuous assignment mux
    assign out_assign = sel_combined ? b : a;

    // Use a procedural case statement to implement the mux for out_always
    always @(*) begin
        case(sel_combined)
            1'b0: out_always = a;
            1'b1: out_always = b;
            default: out_always = 1'bx; // X to indicate undefined state if any
        endcase
    end

endmodule