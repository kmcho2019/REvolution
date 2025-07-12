module TopModule(
    input  a,
    input  b,
    input  sel_b1,
    input  sel_b2,
    output out_assign,
    output reg out_always
);

    // User-defined function to encapsulate mux logic
    function mux2to1;
        input sel1, sel2, in_a, in_b;
        begin
            if (sel1 & sel2)
                mux2to1 = in_b;
            else
                mux2to1 = in_a;
        end
    endfunction

    // Continuous assignment using the function
    assign out_assign = mux2to1(sel_b1, sel_b2, a, b);

    // Procedural assignment using the same function inside always block
    always @(*) begin
        out_always = mux2to1(sel_b1, sel_b2, a, b);
    end

endmodule