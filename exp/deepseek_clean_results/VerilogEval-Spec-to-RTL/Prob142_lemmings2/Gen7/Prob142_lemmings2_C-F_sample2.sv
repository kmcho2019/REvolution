module TopModule (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    output walk_left,
    output walk_right,
    output aaah
);

    reg walking_dir;  // 0=left, 1=right
    reg falling;

    always @(posedge clk, posedge areset) begin
        if (areset) begin
            walking_dir <= 0;  // Start walking left
            falling <= 0;
        end
        else if (falling) begin
            if (ground) falling <= 0;  // Stop falling when ground reappears
        end
        else if (!ground) begin
            falling <= 1;  // Start falling when ground disappears
        end
        else if ((walking_dir ? bump_right : bump_left)) begin
            walking_dir <= ~walking_dir;  // Change direction when bumped
        end
    end

    assign walk_left = ~falling & ~walking_dir;
    assign walk_right = ~falling & walking_dir;
    assign aaah = falling;

endmodule