module TopModule (
    input in,
    output out
);
    // Explicit wire connection style
    wire internal_connection;
    assign internal_connection = in;
    assign out = internal_connection;
endmodule