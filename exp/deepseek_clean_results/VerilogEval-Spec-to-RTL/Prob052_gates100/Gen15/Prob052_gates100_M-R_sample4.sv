module TopModule (
    input [99:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    // Directly compute final outputs using hierarchical reduction operators
    assign out_and = &{ &in[99:75], &in[74:50], &in[49:25], &in[24:0] };
    assign out_or  = |{ |in[99:75], |in[74:50], |in[49:25], |in[24:0] };
    assign out_xor = ^{ ^in[99:75], ^in[74:50], ^in[49:25], ^in[24:0] };

endmodule