module TopModule(
    input  [254:0] in,  // 255-bit input
    output [7:0] out    // 8-bit output
);

    // Initialize the output
    reg [7:0] count;

    // Always block to count the number of '1's
    always @(*) begin
        count = 8'd0;  // Reset count to 0
        for (int i = 0; i < 255; i++) begin
            if (in[i] == 1'b1) begin
                count = count + 1;
            end
        end
    end

    // Assign the count to output
    assign out = count;

endmodule