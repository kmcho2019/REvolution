module TopModule (
    input         clk,
    input         load,
    input  [511:0] data,
    output [511:0] q
);
    reg [511:0] state;

    // Pad with zeros at boundaries
    wire [512:0] left_padded  = {1'b0, state};          // zero on left boundary, size 513
    wire [512:0] right_padded = {state, 1'b0};          // zero on right boundary, size 513

    // Next state calculation: next_state[i] = left_neighbor XOR right_neighbor
    wire [511:0] next_state = left_padded[510: -1 +1] ^ right_padded[512-1:0];

    // Explanation for indexing:
    // For i in 0 to 511, 
    // left neighbor = state[i-1] or 0 if i=0 (left_padded shifted right by 1)
    // right neighbor = state[i+1] or 0 if i=511 (right_padded shifted left by 1)
    // Here left_padded[510: -1+1] = left_padded[510:0]
    // right_padded[512-1:0] = right_padded[511:0]
    // Thus next_state = left_padded[510:0] ^ right_padded[511:0]

    // However, indexing needs to be carefully handled in Verilog (no negative index).
    // We re-derive correctly below:

    // left neighbors for bits 0..511: state[i-1], with 0 for i=0
    // stored in left_padded[511:0] = {0, state[511:1]}
    wire [511:0] left_neighbors = left_padded[511:0]; 

    // right neighbors for bits 0..511: state[i+1], with 0 for i=511
    // stored in right_padded[511:0] = {state[510:0],0}
    wire [511:0] right_neighbors = right_padded[511:0];

    wire [511:0] next_state_correct = left_neighbors ^ right_neighbors;

    // Sequential state update
    always @(posedge clk) begin
        if (load)
            state <= data;
        else
            state <= next_state_correct;
    end

    assign q = state;

endmodule