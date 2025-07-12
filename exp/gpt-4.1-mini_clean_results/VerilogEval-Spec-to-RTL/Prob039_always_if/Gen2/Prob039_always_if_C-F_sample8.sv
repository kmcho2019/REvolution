module TopModule (
    input  a,
    input  b,
    input  sel_b1,
    input  sel_b2,
    output out_assign,
    output reg out_always
);

    // Compute select signal once to share logic
    wire select = sel_b1 & sel_b2;

    // Continuous assignment using the select signal
    assign out_assign = select ? b : a;

    // Procedural always block using if statement on the select signal
    always @(*) begin
        if (select)
            out_always = b;
        else
            out_always = a;
    end

endmodule