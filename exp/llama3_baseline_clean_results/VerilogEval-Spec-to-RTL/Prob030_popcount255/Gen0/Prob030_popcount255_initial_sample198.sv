module TopModule(
    input [254:0] in,  // 255-bit input vector
    output [7:0] out   // 8-bit output
);

    // Initialize count variable
    reg [7:0] count;

    // Always block to calculate the population count
    always @(*) begin
        count = 8'd0;  // Reset count to 0
        for (int i = 0; i < 255; i++) begin
            // If the current bit is '1', increment the count
            if (in[i]) begin
                count = count + 1'b1;
            end
        end
    end

    // Assign the count to the output
    assign out = count;

endmodule