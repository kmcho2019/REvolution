module TopModule (
    input  [2:0] in,
    output [1:0] out
);

    // Temporary variable to accumulate the count
    reg [1:0] count;

    // Calculate the count of '1's in the input vector
    always @(*) begin
        count = 1'b0;
        if (in[0]) count = count + 1'b1;
        if (in[1]) count = count + 1'b1;
        if (in[2]) count = count + 1'b1;
    end

    // Assign the calculated count to the output
    assign out = count;

endmodule