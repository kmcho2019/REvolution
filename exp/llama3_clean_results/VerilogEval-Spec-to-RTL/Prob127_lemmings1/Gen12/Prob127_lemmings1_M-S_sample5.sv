module TopModule(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output logic walk_left,
    output logic walk_right
);

reg state; // Using a 1-bit state variable

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 0; // Initialize state to LEFT (0)
        walk_left <= 1;
        walk_right <= 0;
    end else begin
        if (bump_left || bump_right) begin
            state <= ~state; // Switch state
        end
        walk_left <= ~state;
        walk_right <= state;
    end
end

endmodule