module TopModule (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output walk_left,
    output walk_right
);

    // State register holds output pattern directly:
    // 2'b01 = walk left (left=1, right=0)
    // 2'b10 = walk right (left=0, right=1)
    reg [1:0] state;

    // Outputs are directly wired from state bits
    assign {walk_right, walk_left} = state;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Initialize to walk left (01)
            state <= 2'b01;
        end else begin
            // Compact transition logic using bit operations
            case ({bump_left, bump_right})
                2'b10: state <= 2'b10;  // Left bump -> go right
                2'b01: state <= 2'b01;  // Right bump -> go left
                2'b11: state <= ~state; // Both bumps -> toggle direction
                default: state <= state; // No bumps -> maintain direction
            endcase
        end
    end

endmodule