module TopModule(
    input  wire a,
    input  wire b,
    input  wire sel_b1,
    input  wire sel_b2,
    output wire out_assign,
    output reg  out_always
);
    // Combine select signals once
    wire sel_combined = sel_b1 & sel_b2;

    // Continuous assignment mux for out_assign
    assign out_assign = sel_combined ? b : a;

    // Procedural always block mux for out_always
    always @(*) begin
        if (sel_combined)
            out_always = b;
        else
            out_always = a;
    end

endmodule