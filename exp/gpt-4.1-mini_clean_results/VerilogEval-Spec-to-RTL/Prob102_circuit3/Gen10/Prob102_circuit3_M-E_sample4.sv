module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);

    // Function to compute the output logic
    function automatic logic compute_q(input logic a_in, input logic b_in, input logic c_in, input logic d_in);
        begin
            compute_q = (a_in | b_in) & (c_in | d_in);
        end
    endfunction

    assign q = compute_q(a, b, c, d);

endmodule