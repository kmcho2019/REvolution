module TopModule(
    input  wire a,
    input  wire b,
    input  wire sel_b1,
    input  wire sel_b2,
    output wire out_assign,
    output reg  out_always
);

    wire sel_final;
    assign sel_final = sel_b1 & sel_b2;

    // Local function for 2-to-1 mux
    function automatic mux2to1;
        input wire a_in, b_in, sel_in;
        begin
            mux2to1 = sel_in ? b_in : a_in;
        end
    endfunction

    // Continuous assignment using mux function
    assign out_assign = mux2to1(a, b, sel_final);

    // Procedural mux with if statement
    always @(*) begin
        if (sel_final)
            out_always = b;
        else
            out_always = a;
    end

endmodule