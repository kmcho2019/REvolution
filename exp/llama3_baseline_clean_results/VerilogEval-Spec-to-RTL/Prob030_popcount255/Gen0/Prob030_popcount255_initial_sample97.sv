module TopModule(
    input  [254:0] in,
    output [7:0] out
);

    // Initialize wires to hold counts for each 8-bit chunk
    wire [7:0] chunk_count [31:0];
    wire [2:0] leftover_count;

    // Calculate count for each 8-bit chunk
    genvar i;
    generate
        for (i = 0; i < 32; i = i + 1) begin
            pop_count #(.WIDTH(8)) u_pop_count(
                .in(in[(i*8)+:8]),
                .out(chunk_count[i])
            );
        end
    endgenerate

    // Calculate count for leftover 7 bits
    pop_count #(.WIDTH(7)) u_leftover_pop_count(
        .in(in[254:247]),
        .out(leftover_count)
    );

    // Sum up counts from all chunks and leftover bits
    wire [7:0] sum;
    assign sum = chunk_count[0];
    genvar j;
    generate
        for (j = 1; j < 32; j = j + 1) begin
            assign sum = sum + chunk_count[j];
        end
    endgenerate

    // Add leftover count to sum
    assign out = sum + leftover_count;

endmodule

// Population count module for any width
module pop_count #(
    parameter WIDTH = 8
)(
    input  [WIDTH-1:0] in,
    output [7:0] out
);

    wire [WIDTH-1:0] temp_in;
    assign temp_in = in;

    reg [7:0] count;
    integer k;
    always @(temp_in) begin
        count = 0;
        for (k = 0; k < WIDTH; k = k + 1) begin
            if (temp_in[k]) begin
                count = count + 1;
            end
        end
    end

    assign out = count;

endmodule