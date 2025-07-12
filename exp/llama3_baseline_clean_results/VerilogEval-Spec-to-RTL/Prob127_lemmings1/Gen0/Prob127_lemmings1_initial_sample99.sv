module TopModule (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output walk_left,
    output walk_right
);

reg walking_left; // register to store the current state
reg walking_right; // register to store the current state

always @(posedge areset or posedge clk) begin
    if (areset) begin // asynchronous reset
        walking_left <= 1;
        walking_right <= 0;
    end else begin
        if (bump_left) begin
            walking_left <= 0;
            walking_right <= 1;
        end else if (bump_right) begin
            walking_left <= 1;
            walking_right <= 0;
        end
    end
end

assign walk_left = walking_left;
assign walk_right = walking_right;

endmodule