module TopModule (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output walk_left,
    output walk_right
);

    // One-hot state encoding
    wire state_left, state_right;
    
    // State register implemented as DFFs
    dff state_left_ff (
        .clk(clk),
        .arst(areset),
        .d((state_left & ~bump_left) | (state_right & bump_right)),
        .q(state_left)
    );
    
    dff state_right_ff (
        .clk(clk),
        .arst(areset),
        .d((state_right & ~bump_right) | (state_left & bump_left)),
        .q(state_right)
    );
    
    // Initialize to walk left (state_left = 1)
    initial begin
        state_left_ff.q = 1'b1;
        state_right_ff.q = 1'b0;
    end

    // Output assignments
    assign walk_left = state_left;
    assign walk_right = state_right;

endmodule

// Simple D flip-flop with async reset
module dff (
    input clk,
    input arst,
    input d,
    output reg q
);
    always @(posedge clk or posedge arst) begin
        if (arst) q <= 1'b0;
        else q <= d;
    end
endmodule