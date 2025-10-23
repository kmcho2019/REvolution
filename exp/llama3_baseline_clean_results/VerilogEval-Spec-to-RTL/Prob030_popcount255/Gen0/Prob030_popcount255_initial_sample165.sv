module TopModule(
    input  [255:0] in,
    output [7:0] out
);

    wire [7:0] byte_count [31:0];
    reg  [7:0] sum_count;

    // Calculate population count for each byte
    genvar i;
    generate
        for (i = 0; i < 32; i = i + 1) begin
            PopCount #(.WIDTH(8)) byte_pop_count(
               .in(in[(i*8)+:8]),
               .out(byte_count[i])
            );
        end
    endgenerate

    // Sum up the population counts of all bytes
    always @(*) begin
        sum_count = 8'd0;
        for (int j = 0; j < 32; j++) begin
            sum_count = sum_count + byte_count[j];
        end
    end

    assign out = sum_count;

endmodule

// Population count module for an 8-bit vector
module PopCount #(
    parameter WIDTH = 8
)(
    input  [WIDTH-1:0] in,
    output [7:0] out
);

    reg [7:0] count;

    always @(*) begin
        count = 8'd0;
        for (int i = 0; i < WIDTH; i++) begin
            if (in[i]) begin
                count = count + 1;
            end
        end
    end

    assign out = count;

endmodule