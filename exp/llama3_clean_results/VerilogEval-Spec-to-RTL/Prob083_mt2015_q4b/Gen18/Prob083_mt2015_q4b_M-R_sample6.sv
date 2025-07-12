module TopModule(
    input x,
    input y,
    output logic z
);

    // Refactored implementation using AND and OR gates
    assign z = (x & y) | (~x & ~y);

    // Alternatively, using an if statement within an always block
    // always @(x or y) begin
    //     if (x == y) begin
    //         z = 1'b1;
    //     end else begin
    //         z = 1'b0;
    //     end
    // end

    // Or, explicitly breaking down the logic into separate steps
    // logic xor_result;
    // assign xor_result = x ^ y;
    // assign z = ~xor_result;

endmodule