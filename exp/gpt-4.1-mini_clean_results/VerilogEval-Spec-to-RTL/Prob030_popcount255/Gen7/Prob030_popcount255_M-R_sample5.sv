module popcount4 (
    input  [3:0] in,
    output [2:0] out  // max count 4 fits in 3 bits
);
    // Simple reduction with '+' operator; synthesis infers efficient logic
    assign out = in[0] + in[1] + in[2] + in[3];
endmodule

module popcount17 (
    input  [16:0] in,
    output [5:0] out  // max 17 ones, 6 bits safe
);
    wire [2:0] pc [3:0];

    // Instantiate four popcount4 for first 16 bits
    genvar i;
    generate
        for (i=0; i<4; i=i+1) begin : pcs
            popcount4 pc_inst (.in(in[i*4 +: 4]), .out(pc[i]));
        end
    endgenerate

    // Sum partial popcounts and leftover bit in one step
    // Concatenate the 4 pc outputs and leftover bit for addition
    wire [6:0] sum16 = pc[0] + pc[1] + pc[2] + pc[3] + in[16];
    assign out = sum16;
endmodule

module TopModule (
    input  [254:0] in,
    output reg [7:0] out
);
    localparam N = 15; // Number of 17-bit blocks

    wire [5:0] partial_counts [N-1:0];

    genvar idx;
    generate
        for (idx = 0; idx < N; idx = idx + 1) begin : pc17_blocks
            popcount17 pc_inst (
                .in(in[idx*17 +: 17]),
                .out(partial_counts[idx])
            );
        end
    endgenerate

    // Combine partial counts using iterative reduction inside combinational always block
    // Array to hold current summation stage values, width extended to 8 bits for sum up to 255
    reg [7:0] stage_values [N-1:0];
    integer stage_len;
    integer i;

    always @* begin
        // Initialize stage_values from partial_counts
        for (i = 0; i < N; i = i + 1) begin
            stage_values[i] = {2'b00, partial_counts[i]}; // zero extend from 6 to 8 bits
        end

        stage_len = N;

        // Iteratively sum pairs until one value remains
        while (stage_len > 1) begin
            for (i = 0; i < stage_len/2; i = i + 1) begin
                stage_values[i] = stage_values[2*i] + stage_values[2*i+1];
            end
            if (stage_len % 2) begin
                // Odd number: carry last element up
                stage_values[stage_len/2] = stage_values[stage_len - 1];
                stage_len = stage_len/2 + 1;
            end else begin
                stage_len = stage_len/2;
            end
        end

        out = stage_values[0];
    end
endmodule