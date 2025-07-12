module TopModule(
    input  in,
    output out
);
    // Implementing a NOT gate using a 2-to-1 multiplexer
    assign out = (in == 1'b0)? 1'b1 : 1'b0;
endmodule