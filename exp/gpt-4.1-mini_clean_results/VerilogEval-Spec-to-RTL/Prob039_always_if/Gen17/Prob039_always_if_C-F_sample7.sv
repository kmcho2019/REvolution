module TopModule(
    input  wire a,
    input  wire b,
    input  wire sel_b1,
    input  wire sel_b2,
    output wire out_assign,
    output reg  out_always
);

    // Compute combined select signal
    wire sel_final = sel_b1 & sel_b2;

    // Continuous assignment mux: choose b if sel_final, else a
    assign out_assign = sel_final ? b : a;

    // Procedural mux using if-else for clarity and performance
    always @(*) begin
        if (sel_final)
            out_always = b;
        else
            out_always = a;
    end

endmodule