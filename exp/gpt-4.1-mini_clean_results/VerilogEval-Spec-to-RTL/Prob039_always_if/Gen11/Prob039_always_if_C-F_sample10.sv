module TopModule (
    input  a,
    input  b,
    input  sel_b1,
    input  sel_b2,
    output out_assign,
    output reg out_always
);

    // Selection condition computed once
    wire use_b = sel_b1 & sel_b2;

    // Function encapsulating mux logic using select signal
    function automatic mux_select;
        input a_in;
        input b_in;
        input sel;
        begin
            mux_select = sel ? b_in : a_in;
        end
    endfunction

    // Compute mux output once using the function and shared select
    wire mux_out = mux_select(a, b, use_b);

    // Continuous assignment driven by shared mux output
    assign out_assign = mux_out;

    // Procedural assignment driven by shared mux output
    always @(*) begin
        out_always = mux_out;
    end

endmodule