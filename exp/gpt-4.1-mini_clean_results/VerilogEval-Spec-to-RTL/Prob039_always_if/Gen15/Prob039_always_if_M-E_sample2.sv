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

    // Function to implement 2-to-1 mux
    function automatic mux_func;
        input a_in;
        input b_in;
        input sel_in;
        begin
            mux_func = sel_in ? b_in : a_in;
        end
    endfunction

    // Continuous assignment using the function
    assign out_assign = mux_func(a, b, sel_final);

    // Procedural block using case statement for mux logic
    always @(*) begin
        case (sel_final)
            1'b0: out_always = a;
            1'b1: out_always = b;
            default: out_always = 1'b0; // default safe assignment
        endcase
    end

endmodule