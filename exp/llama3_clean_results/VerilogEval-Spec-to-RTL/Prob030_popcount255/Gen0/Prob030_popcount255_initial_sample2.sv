module TopModule(
    input [254:0] in,
    output [7:0] out
);

    // Initialize the output
    reg [7:0] count;

    // Initialize temporary variables for counting '1's in each bit position
    reg [7:0] temp_count;

    // Use an always block to continuously update the count
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