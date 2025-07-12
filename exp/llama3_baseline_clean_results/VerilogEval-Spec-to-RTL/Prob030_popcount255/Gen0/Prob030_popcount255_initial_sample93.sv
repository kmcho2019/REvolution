module TopModule (
    input  [254:0] in,
    output [7:0] out
);

    wire [7:0] count;

    // Initialize count to 0
    assign count = {8{1'b0}};

    // Count the number of '1's in the input vector
    always @(in) begin
        count = 8'b0;
        for (int i = 0; i < 255; i++) begin
            if (in[i]) begin
                count = count + 1;
            end
        end
    end

    // Assign the count to the output
    assign out = count;

endmodule