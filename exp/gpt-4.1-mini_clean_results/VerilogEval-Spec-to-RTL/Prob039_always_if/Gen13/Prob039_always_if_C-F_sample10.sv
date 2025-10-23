module TopModule (
    input  wire a,
    input  wire b,
    input  wire sel_b1,
    input  wire sel_b2,
    output wire out_assign,
    output reg  out_always
);

    // Shared select signal to reduce redundant logic
    wire use_b = sel_b1 & sel_b2;

    // Continuous assignment mux using shared select
    assign out_assign = use_b ? b : a;

    // Procedural mux using the same shared select inside always block
    always @(*) begin
        if (use_b)
            out_always = b;
        else
            out_always = a;
    end

endmodule