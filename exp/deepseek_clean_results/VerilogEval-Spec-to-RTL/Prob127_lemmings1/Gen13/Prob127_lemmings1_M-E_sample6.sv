module TopModule (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output walk_left,
    output walk_right
);

    reg direction;  // 0 = left, 1 = right
    reg last_bump_left, last_bump_right;

    // Edge detection for bump signals
    wire bump_left_edge = bump_left && !last_bump_left;
    wire bump_right_edge = bump_right && !last_bump_right;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            direction <= 0;
            last_bump_left <= 0;
            last_bump_right <= 0;
        end else begin
            last_bump_left <= bump_left;
            last_bump_right <= bump_right;
            
            // Toggle direction on any bump edge
            if ((direction && bump_right_edge) || (!direction && bump_left_edge)) begin
                direction <= ~direction;
            end
        end
    end

    assign walk_left = ~direction;
    assign walk_right = direction;

endmodule