module TopModule(
    input  [255:0] in,
    output [7:0] out
);

    // Count the number of '1's in each byte
    wire [7:0] byte_counts [31:0];
    genvar i;
    generate
        for (i = 0; i < 32; i++) begin
            population_count_byte byte_counter(
                .in(in[8*i+7:8*i]),
                .out(byte_counts[i])
            );
        end
    endgenerate

    // Sum up the counts from each byte
    wire [7:0] sum;
    assign sum = byte_counts[0];
    for (genvar j = 1; j < 32; j++) begin
        assign out = sum + byte_counts[j];
    end

    // But the above is not synthesizable.
    // We can do the following instead.
    assign out = {8{1'b0}};
    always @(*) begin
        out = 8'd0;
        for (int k = 0; k < 255; k++) begin
            if (in[k]) begin
                out = out + 1;
            end
        end
    end

endmodule

module population_count_byte(
    input  [7:0] in,
    output [7:0] out
);
    assign out = {8{1'b0}};
    always @(*) begin
        out = 8'd0;
        for (int i = 0; i < 8; i++) begin
            if (in[i]) begin
                out = out + 1;
            end
        end
    end
endmodule