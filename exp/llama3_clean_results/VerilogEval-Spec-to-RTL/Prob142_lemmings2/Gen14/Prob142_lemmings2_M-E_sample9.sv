module TopModule(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    output walk_left,
    output walk_right,
    output aaah
);

reg [1:0] state; // 2 bits: walking direction (1 bit) and falling state (1 bit)
reg [7:0] fall_count; // counter to track number of clock cycles since ground disappeared

always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b01; // initialize walking direction to left and falling state to 0
        fall_count <= 8'b0;
    end else begin
        if (~ground) begin
            state[1] <= 1'b1; // set falling state to 1 when ground disappears
            fall_count <= fall_count + 1'b1;
        end else begin
            state[1] <= 1'b0; // reset falling state to 0 when ground appears
            fall_count <= 8'b0;
        end

        if (bump_left && ~state[1]) begin
            state[0] <= 1'b0; // switch walking direction to right when bumped on left
        end else if (bump_right && ~state[1]) begin
            state[0] <= 1'b1; // switch walking direction to left when bumped on right
        end
    end
end

assign walk_left = (state[0] && ~state[1]);
assign walk_right = (~state[0] && ~state[1]);
assign aaah = state[1];

endmodule