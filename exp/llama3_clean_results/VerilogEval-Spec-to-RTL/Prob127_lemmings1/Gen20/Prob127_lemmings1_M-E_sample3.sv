module TopModule(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output logic walk_left,
    output logic walk_right
);

reg direction; // Register to store the current direction

always @(posedge clk or posedge areset) begin
    if (areset) begin
        direction <= 1'b0; // Initialize direction to walking left
    end else begin
        if (bump_left || bump_right) begin
            direction <= ~direction; // Toggle direction when hitting an obstacle
        end
    end
end

always @(direction) begin
    case (direction)
        1'b0: begin
            walk_left = 1'b1;
            walk_right = 1'b0;
        end
        1'b1: begin
            walk_left = 1'b0;
            walk_right = 1'b1;
        end
    endcase
end

endmodule