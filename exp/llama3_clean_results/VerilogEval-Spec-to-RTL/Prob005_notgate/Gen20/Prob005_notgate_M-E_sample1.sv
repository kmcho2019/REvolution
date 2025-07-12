// Module declaration for a NOT gate using a multiplexer
module TopModule(
    input  in,  // Input to the NOT gate
    output out   // Output of the NOT gate
);
    // Use a multiplexer with select line driven by the input
    // to conditionally select between '0' and '1'
    assign out = in? 1'b0 : 1'b1;
endmodule