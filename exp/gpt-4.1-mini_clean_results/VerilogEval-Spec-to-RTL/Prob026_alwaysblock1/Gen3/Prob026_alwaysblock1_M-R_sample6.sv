module TopModule(
    input  a,
    input  b,
    output out_assign,
    output out_alwaysblock
);

    // Continuous assignment for out_assign
    assign out_assign = a & b;

    // Function to perform AND operation
    function automatic and_func;
        input a_in;
        input b_in;
        begin
            and_func = a_in & b_in;
        end
    endfunction

    // Use function output for out_alwaysblock
    assign out_alwaysblock = and_func(a, b);

endmodule