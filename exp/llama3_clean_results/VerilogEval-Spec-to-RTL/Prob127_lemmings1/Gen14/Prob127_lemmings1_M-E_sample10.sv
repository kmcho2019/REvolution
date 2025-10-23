module TopModule(
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    output reg walk_left,
    output reg walk_right
);

reg [1:0] counter; // 2-bit counter

always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        counter <= 2'b00; // Reset counter
        walk_left <= 1'b1; // Start walking left
        walk_right <= 1'b0;
    end else begin
        if (bump_left && bump_right) begin
            // Switch direction if bumped from both sides
            walk_left <= ~walk_left;
            walk_right <= ~walk_right;
        end else if (bump_left) begin
            // Increment counter if bumped from the left
            counter <= counter + 1;
            if (counter == 2'b11) begin
                // Switch direction if counter reaches maximum value
                walk_left <= 1'b0;
                walk_right <= 1'b1;
                counter <= 2'b00; // Reset counter
            end
        end else if (bump_right) begin
            // Decrement counter if bumped from the right
            counter <= counter - 1;
            if (counter == 2'b00) begin
                // Switch direction if counter reaches minimum value
                walk_left <= 1'b1;
                walk_right <= 1'b0;
                counter <= 2'b00; // Reset counter
            end
        end
    end
end

endmodule