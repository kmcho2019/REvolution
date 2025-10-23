module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out,
    output out_n
);
    // First layer: AND operations with descriptive names
    wire first_and_out = a & b;
    wire second_and_out = c & d;
    
    // Second layer: OR operation combining AND outputs
    assign out = first_and_out | second_and_out;
    
    // Inverted output
    assign out_n = ~out;
endmodule