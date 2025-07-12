module TopModule (
    input  wire in,
    output wire out
);
    // Function abstraction inside the module for clarity and extensibility
    function automatic logic invert_bit(input logic bit_in);
        invert_bit = ~bit_in;
    endfunction

    assign out = invert_bit(in);
endmodule