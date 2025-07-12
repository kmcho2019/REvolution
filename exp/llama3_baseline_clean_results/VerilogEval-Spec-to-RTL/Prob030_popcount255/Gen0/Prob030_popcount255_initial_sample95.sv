module TopModule(
    input  [254:0] in,  // 255-bit input vector
    output [7:0] out   // 8-bit output for population count
);

    // Initialize a variable to hold the count
    reg [7:0] count;

    // Initialize the count to 0
    initial count = 8'd0;

    // Count the number of '1's in the input vector
    always @(in) begin
        count = 8'd0;
        for (int i = 0; i < 255; i++) begin
            if (in[i])
                count = count + 8'd1;
        end
    end

    // Assign the count to the output
    assign out = count;

endmodule