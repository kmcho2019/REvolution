module TopModule (
    input  a,
    input  b,
    input  sel_b1,
    input  sel_b2,
    output out_assign,
    output reg out_always
);

    // Function that encapsulates mux selection logic
    function automatic mux_select;
        input a_in;
        input b_in;
        input sel1;
        input sel2;
        begin
            mux_select = (sel1 & sel2) ? b_in : a_in;
        end
    endfunction

    // Use function in continuous assignment
    assign out_assign = mux_select(a, b, sel_b1, sel_b2);

    // Use function inside procedural always block
    always @(*) begin
        out_always = mux_select(a, b, sel_b1, sel_b2);
    end

endmodule