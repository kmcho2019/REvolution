`define LEFT 2'b00
`define RIGHT 2'b01

module TopModule(
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    output walk_left,
    output walk_right
);

reg [1:0] state;
reg [1:0] next_state;

always @(posedge clk or posedge areset) begin
    if(areset) begin
        state <= `LEFT;
    end else begin
        state <= next_state;
    end
end

always @(*) begin
    case(state)
        `LEFT: begin
            if(bump_left) begin
                next_state <= `RIGHT;
            end else begin
                next_state <= `LEFT;
            end
        end
        `RIGHT: begin
            if(bump_right) begin
                next_state <= `LEFT;
            end else begin
                next_state <= `RIGHT;
            end
        end
        default: begin
            next_state <= `LEFT;
        end
    endcase
end

always @(*) begin
    case(state)
        `LEFT: begin
            walk_left <= 1'b1;
            walk_right <= 1'b0;
        end
        `RIGHT: begin
            walk_left <= 1'b0;
            walk_right <= 1'b1;
        end
        default: begin
            walk_left <= 1'b1;
            walk_right <= 1'b0;
        end
    endcase
end

endmodule