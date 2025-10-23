module TopModule(
    input  wire a,
    input  wire b,
    input  wire sel_b1,
    input  wire sel_b2,
    output wire out_assign,
    output reg  out_always
);

    wire sel = sel_b1 & sel_b2;

    // Single mux output wire combining the selection logic once
    wire mux_out;

    // Implement mux logic once, using a local function for clarity and reuse
    function automatic mux2to1;
        input wire a_in, b_in, sel_in;
        begin
            mux2to1 = sel_in ? b_in : a_in;
        end
    endfunction

    assign mux_out = mux2to1(a, b, sel);

    // Continuous assign output directly driven from mux_out
    assign out_assign = mux_out;

    // Procedural assignment to out_always using the single mux output
    always @(*) begin
        if (sel)
            out_always = b;
        else
            out_always = a;
    end

endmodule