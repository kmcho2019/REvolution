module TopModule(
    input  wire a,
    input  wire b,
    input  wire sel_b1,
    input  wire sel_b2,
    output wire out_assign,
    output reg  out_always
);

    // Function to implement the mux logic: select b only if both sel_b1 and sel_b2 are high
    function automatic logic select_mux(input logic a_in, input logic b_in, input logic sel1, input logic sel2);
        begin
            if (sel1 && sel2)
                select_mux = b_in;
            else
                select_mux = a_in;
        end
    endfunction

    // Continuous assignment using the select_mux function
    assign out_assign = select_mux(a, b, sel_b1, sel_b2);

    // Procedural block using an if statement to assign out_always
    always @(*) begin
        if (sel_b1 && sel_b2)
            out_always = b;
        else
            out_always = a;
    end

endmodule