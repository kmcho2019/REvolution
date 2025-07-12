module TopModule (
    input  wire a,
    input  wire b,
    output wire sum,
    output wire cout
);

    // Continuous assignments implement half adder logic directly
    assign sum = a ^ b;
    assign cout = a & b;

endmodule