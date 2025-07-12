module TopModule(
    input [254:0] in,
    output [7:0] out
);

    // Initialize variables to hold counts
    reg [7:0] count;

    // Assign count to 0
    always @(*) begin
        count = 8'd0;
        for (int i = 0; i < 255; i++) begin
            if (in[i]) begin
                count = count + 1'b1;
            end
        end
    end

    // Assign output
    assign out = count;

endmodule