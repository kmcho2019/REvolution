module TopModule(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output reg walk_left,
    output reg walk_right
);

reg [1:0] state;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        walk_left <= 1'b1;
        walk_right <= 1'b0;
    end else begin
        case ({bump_left, bump_right})
            2'b00: begin
                walk_left <= walk_left;
                walk_right <= walk_right;
            end
            2'b01: begin
                walk_left <= 1'b1;
                walk_right <= 1'b0;
            end
            2'b10: begin
                walk_left <= 1'b0;
                walk_right <= 1'b1;
            end
            2'b11: begin
                walk_left <= ~walk_left;
                walk_right <= ~walk_right;
            end
        endcase
    end
end

endmodule