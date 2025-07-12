module TopModule(
    input  a,
    input  b,
    output out
);

    wire and_out;
    wire or_out;

    and and_inst(a, b, and_out);
    or or_inst(a, b, or_out);

    assign out = ~(and_out ^ or_out); // Simplified to match XNOR behavior

    // Alternatively, using a multiplexer approach as initially thought:
    // assign out = (a == b) ? 1'b1 : 1'b0;
    // The direct comparison is more efficient and straightforward.

endmodule