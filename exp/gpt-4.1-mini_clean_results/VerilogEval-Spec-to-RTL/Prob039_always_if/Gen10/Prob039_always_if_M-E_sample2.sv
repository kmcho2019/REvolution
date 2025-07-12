module TopModule(
    input  a,
    input  b,
    input  sel_b1,
    input  sel_b2,
    output out_assign,
    output reg out_always
);

    // Internal combinational signal holding mux result
    reg mux_out;

    // Combinational logic to select input
    always @(*) begin
        if (sel_b1 & sel_b2)
            mux_out = b;
        else
            mux_out = a;
    end

    // Assign continuous output from internal signal
    assign out_assign = mux_out;

    // Procedural output driven directly from internal signal
    always @(*) begin
        out_always = mux_out;
    end

endmodule