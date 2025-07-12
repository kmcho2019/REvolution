module TopModule (
    input a,
    input b,
    output out_assign,
    output out_alwaysblock
);

    // Implementation using assign statement (unchanged)
    assign out_assign = a & b;

    // Alternative implementation using always block with wire output
    wire temp;
    always @(*) begin
        assign temp = a & b;
    end
    assign out_alwaysblock = temp;

endmodule