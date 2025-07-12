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

    reg state;  // 0=LEFT, 1=RIGHT

    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= 0;
        end
        else if (ground) begin
            if ((state && bump_right) || (!state && bump_left)) begin
                state <= ~state;
            end
        end
    end

    assign walk_left = ground & ~state;
    assign walk_right = ground & state;
    assign aaah = ~ground;

endmodule