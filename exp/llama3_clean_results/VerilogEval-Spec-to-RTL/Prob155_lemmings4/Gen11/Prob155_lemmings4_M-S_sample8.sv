module TopModule(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    input dig,
    output reg walk_left,
    output reg walk_right,
    output reg aaah,
    output reg digging
);

reg [4:0] fall_counter;

always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        walk_left <= 1'b1;
        walk_right <= 1'b0;
        aaah <= 1'b0;
        digging <= 1'b0;
        fall_counter <= 5'b0;
    end else begin
        if (~ground) begin
            walk_left <= 1'b0;
            walk_right <= 1'b0;
            aaah <= 1'b1;
            digging <= 1'b0;
            fall_counter <= fall_counter + 1'b1;
        end else if (dig && ~aaah) begin
            walk_left <= 1'b0;
            walk_right <= 1'b0;
            aaah <= 1'b0;
            digging <= 1'b1;
        end else if (bump_left || bump_right) begin
            walk_left <= ~walk_left;
            walk_right <= ~walk_right;
            aaah <= 1'b0;
            digging <= 1'b0;
            fall_counter <= 5'b0;
        end else if (aaah && ground) begin
            if (fall_counter > 5'd20) begin
                walk_left <= 1'b0;
                walk_right <= 1'b0;
                aaah <= 1'b0;
                digging <= 1'b0;
            end else begin
                walk_left <= ~walk_right;
                walk_right <= ~walk_left;
                aaah <= 1'b0;
                digging <= 1'b0;
                fall_counter <= 5'b0;
            end
        end else begin
            walk_left <= walk_left;
            walk_right <= walk_right;
            aaah <= 1'b0;
            digging <= digging;
            fall_counter <= fall_counter;
        end
    end
end

endmodule