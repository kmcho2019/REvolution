module TopModule(
    input  logic clk,
    input  logic areset,
    input  logic bump_left,
    input  logic bump_right,
    input  logic ground,
    output logic walk_left,
    output logic walk_right,
    output logic aaah
);

// State variables
logic walking_left;
logic is_falling;

// Sequential logic
always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        walking_left <= 1'b1;
        is_falling <= 1'b0;
    end else begin
        if (!ground) begin
            is_falling <= 1'b1;
        end else if (ground && !is_falling) begin
            if (bump_left) begin
                walking_left <= 1'b0;
            end else if (bump_right) begin
                walking_left <= 1'b1;
            end
        end else if (ground && is_falling) begin
            is_falling <= 1'b0;
        end
    end
end

// Output logic
always_comb begin
    walk_left = (ground && walking_left && !is_falling);
    walk_right = (ground && !walking_left && !is_falling);
    aaah = is_falling;
end

endmodule