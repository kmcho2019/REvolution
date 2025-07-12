module TopModule(
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    input  ground,
    output walk_left,
    output walk_right,
    output aaah
);

reg [1:0] state;
reg [1:0] prevState;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b00;
        prevState <= 2'b00;
    end else begin
        case (state)
            2'b00: begin // walking left
                if (!ground) begin
                    state <= 2'b10;
                    prevState <= 2'b00;
                end else if (bump_left) begin
                    state <= 2'b01;
                end
            end
            2'b01: begin // walking right
                if (!ground) begin
                    state <= 2'b10;
                    prevState <= 2'b01;
                end else if (bump_right) begin
                    state <= 2'b00;
                end
            end
            2'b10: begin // falling
                if (ground) begin
                    state <= prevState;
                end
            end
            default: state <= 2'b00;
        endcase
    end
end

always @(*) begin
    case (state)
        2'b00: begin // walking left
            walk_left = 1'b1;
            walk_right = 1'b0;
            aaah = 1'b0;
        end
        2'b01: begin // walking right
            walk_left = 1'b0;
            walk_right = 1'b1;
            aaah = 1'b0;
        end
        2'b10: begin // falling
            walk_left = 1'b0;
            walk_right = 1'b0;
            aaah = 1'b1;
        end
        default: begin
            walk_left = 1'b0;
            walk_right = 1'b0;
            aaah = 1'b0;
        end
    endcase
end

endmodule