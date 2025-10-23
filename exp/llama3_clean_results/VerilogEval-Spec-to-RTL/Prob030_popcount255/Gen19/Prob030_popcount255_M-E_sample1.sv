module TopModule(
    input [254:0] in,
    output [7:0] out
);

    // Divide the input into sets of 3 bits
    wire [1:0] set_counts [84:0];

    // Assign the set counts
    genvar i;
    for (i = 0; i < 85; i++) begin
        reg [1:0] count;
        reg [2:0] temp;

        always @(*) begin
            temp = {in[(i*3)+2], in[(i*3)+1], in[(i*3)]};
            case (temp)
                3'b000: count = 2'b00;
                3'b001, 3'b010, 3'b100: count = 2'b01;
                3'b011, 3'b101, 3'b110: count = 2'b10;
                3'b111: count = 2'b11;
            endcase
        end

        assign set_counts[i] = count;
    end

    // Logarithmic-depth adder tree
    wire [7:0] stage1_sum [42:0];
    wire [7:0] stage2_sum [21:0];
    wire [7:0] stage3_sum [10:0];
    wire [7:0] stage4_sum [5:0];
    wire [7:0] stage5_sum [2:0];
    wire [7:0] final_sum;

    // First stage: 85:42 reduction
    for (i = 0; i < 42; i++) begin
        assign stage1_sum[i] = set_counts[i*2] + set_counts[i*2+1];
    end

    // Second stage: 42:21 reduction
    for (i = 0; i < 21; i++) begin
        assign stage2_sum[i] = stage1_sum[i*2] + stage1_sum[i*2+1];
    end

    // Third stage: 21:10 reduction
    for (i = 0; i < 10; i++) begin
        assign stage3_sum[i] = stage2_sum[i*2] + stage2_sum[i*2+1];
    end

    // Fourth stage: 10:5 reduction
    for (i = 0; i < 5; i++) begin
        assign stage4_sum[i] = stage3_sum[i*2] + stage3_sum[i*2+1];
    end

    // Fifth stage: 5:2 reduction
    for (i = 0; i < 2; i++) begin
        assign stage5_sum[i] = stage4_sum[i*2] + stage4_sum[i*2+1];
    end

    // Final stage: 2:1 reduction with saturation
    assign final_sum = (stage5_sum[0] + stage5_sum[1] > 255) ? 8'd255 : stage5_sum[0] + stage5_sum[1];

    // Assign the output
    assign out = final_sum;

endmodule