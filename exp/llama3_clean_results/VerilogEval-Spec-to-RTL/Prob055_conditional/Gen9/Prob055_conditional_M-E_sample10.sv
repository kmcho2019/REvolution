module TopModule(
    input  [7:0] a,
    input  [7:0] b,
    input  [7:0] c,
    input  [7:0] d,
    output [7:0] min
);

    // Priority encoder
    wire [1:0] min_idx;
    assign min_idx[0] = (a <= b) & (a <= c) & (a <= d);
    assign min_idx[1] = (b <= a) & (b <= c) & (b <= d);
    assign min_idx[2] = (c <= a) & (c <= b) & (c <= d);
    assign min_idx[3] = (d <= a) & (d <= b) & (d <= c);

    // One-hot decoder
    wire [3:0] one_hot;
    assign one_hot[0] = min_idx[0];
    assign one_hot[1] = min_idx[1];
    assign one_hot[2] = min_idx[2];
    assign one_hot[3] = min_idx[3];

    // Multiplexer
    assign min = (one_hot[0]) ? a :
                 (one_hot[1]) ? b :
                 (one_hot[2]) ? c :
                 (one_hot[3]) ? d : 8'b0;

endmodule