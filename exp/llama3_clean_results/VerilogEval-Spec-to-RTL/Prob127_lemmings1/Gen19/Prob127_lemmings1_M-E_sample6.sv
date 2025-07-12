module TopModule(
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    output logic walk_left,
    output logic walk_right
);

reg [1:0] counter;

always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        counter <= 2'b00; // Initialize counter to 0 (walking left)
    end else begin
        if (bump_left && bump_right) begin
            counter <= ~counter + 1; // Switch direction
        end else if (bump_left) begin
            counter <= counter + 1; // Switch to walking right
        end else if (bump_right) begin
            counter <= counter - 1; // Switch to walking left
        end
    end
end

always_comb begin
    if (counter[0] == 1'b0) begin
        walk_left = 1'b1;
        walk_right = 1'b0;
    end else begin
        walk_left = 1'b0;
        walk_right = 1'b1;
    end
end

endmodule