module TopModule(
    input  [254:0] in,
    output [7:0] out
);

    wire [7:0] count_1, count_2, count_3, count_4;
    wire [7:0] temp_count;

    // Divide the 255-bit input into 5 chunks of 51 bits (except the last one which is 55 bits)
    // and count the number of '1's in each chunk
    chunk_counter u1(.in(in[254:204]), .out(count_1));
    chunk_counter u2(.in(in[203:153]), .out(count_2));
    chunk_counter u3(.in(in[152:102]), .out(count_3));
    chunk_counter u4(.in(in[101:51]), .out(count_4));
    chunk_counter u5(.in(in[50:0]), .out(temp_count));

    // Sum up the counts from each chunk
    assign out = count_1 + count_2 + count_3 + count_4 + temp_count;

endmodule

// Module to count the number of '1's in a 51-bit (or 55-bit) vector
module chunk_counter(
    input  [50:0] in,  // Can handle up to 55 bits, but we use 51 bits for simplicity
    output [7:0] out
);

    reg [7:0] count;

    always @(*) begin
        count = 8'd0;
        for (int i = 0; i < 51; i++) begin
            if (in[i])
                count = count + 1;
        end
    end

    assign out = count;

endmodule