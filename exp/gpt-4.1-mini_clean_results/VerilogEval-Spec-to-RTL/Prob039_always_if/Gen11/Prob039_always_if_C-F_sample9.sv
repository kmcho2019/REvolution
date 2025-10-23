module TopModule (
    input  a,
    input  b,
    input  sel_b1,
    input  sel_b2,
    output out_assign,
    output reg out_always
);

    // Function encapsulating mux logic for clarity and reuse inside always block
    function automatic mux_select;
        input a_in;
        input b_in;
        input sel1;
        input sel2;
        begin
            mux_select = (sel1 & sel2) ? b_in : a_in;
        end
    endfunction

    // Compute selection condition once to share between assign and always
    wire use_b = sel_b1 & sel_b2;
    // Compute mux output once to avoid duplicate hardware
    wire mux_out = use_b ? b : a;

    // Continuous assignment uses precomputed mux output
    assign out_assign = mux_out;

    // Procedural assignment uses function for clarity, but passes same inputs
    // Equivalent to using mux_out directly; function reinforces abstraction
    always @(*) begin
        out_always = mux_select(a, b, sel_b1, sel_b2);
        // Alternatively, could do: out_always = mux_out;
        // But keeping function call maintains abstraction and alignment with problem statement
    end

endmodule