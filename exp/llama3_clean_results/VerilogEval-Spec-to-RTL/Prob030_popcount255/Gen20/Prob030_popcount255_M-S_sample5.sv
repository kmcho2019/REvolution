module TopModule(
    input [254:0] in,
    output [7:0] out
);

    // Divide the input into 32 segments of 8 bits
    wire [7:0] segment [31:0];

    // Assign the segments
    genvar i;
    for (i = 0; i < 32; i++) begin
        if (i == 31) begin
            assign segment[i] = {1'b0, in[254:248]};
        end else begin
            assign segment[i] = in[(i*8)+7:i*8];
        end
    end

    // Population counts for each segment
    wire [7:0] segment_count [31:0];

    // Calculate population count for each segment
    for (genvar i = 0; i < 32; i++) begin
        assign segment_count[i] = {8{1'b0}} + $countones(segment[i]);
    end

    // Sum the counts using a hierarchical adder tree
    wire [8:0] mid_sum [15:0];
    for (genvar i = 0; i < 16; i++) begin
        assign mid_sum[i] = {1'b0, segment_count[i*2]} + {1'b0, segment_count[i*2+1]};
    end

    wire [9:0] final_sum [7:0];
    for (genvar i = 0; i < 8; i++) begin
        assign final_sum[i] = {1'b0, mid_sum[i*2]} + {1'b0, mid_sum[i*2+1]};
    end

    wire [10:0] final_sum_last;
    assign final_sum_last = {1'b0, final_sum[6]} + {1'b0, final_sum[7]};

    wire [10:0] final_sum_2;
    assign final_sum_2 = {1'b0, final_sum[0]} + {1'b0, final_sum[1]};

    wire [10:0] final_sum_3;
    assign final_sum_3 = {1'b0, final_sum[2]} + {1'b0, final_sum[3]};

    wire [10:0] final_sum_4;
    assign final_sum_4 = {1'b0, final_sum[4]} + {1'b0, final_sum[5]};

    wire [11:0] final_sum_last_2;
    assign final_sum_last_2 = {1'b0, final_sum_2} + {1'b0, final_sum_3};

    wire [11:0] final_sum_last_3;
    assign final_sum_last_3 = {1'b0, final_sum_4} + {1'b0, final_sum_last};

    wire [11:0] final_sum_last_4;
    assign final_sum_last_4 = {1'b0, final_sum_last_2} + {1'b0, final_sum_last_3};

    assign out = final_sum_last_4[7:0];

endmodule