module TopModule (
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

reg [1:0] state;
reg [4:0] fall_counter;
reg splattered;

assign walk_left = (state == 2'd0);
assign walk_right = (state == 2'd1);
assign aaah = (state == 2'd2);
assign digging = (dig && ground && !splattered);

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'd0;
        fall_counter <= 5'd0;
        splattered <= 1'b0;
    end else begin
        if (splattered) begin
            state <= 2'd2;
        end else if (!ground) begin
            state <= 2'd2;
            fall_counter <= fall_counter + 1;
        end else if (dig) begin
            state <= 2'd0;
        end else if (bump_left && state == 2'd0) begin
            state <= 2'd1;
        end else if (bump_right && state == 2'd1) begin
            state <= 2'd0;
        end
        if (ground && fall_counter > 5'd20) begin
            splattered <= 1'b1;
        end else if (ground) begin
            fall_counter <= 5'd0;
        end
    end
end

endmodule