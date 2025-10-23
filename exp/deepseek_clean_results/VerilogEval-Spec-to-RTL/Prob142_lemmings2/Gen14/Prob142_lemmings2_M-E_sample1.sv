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

    // One-hot state encoding
    parameter WL = 4'b1000;  // Walking Left
    parameter WR = 4'b0100;  // Walking Right
    parameter FL = 4'b0010;  // Falling Left
    parameter FR = 4'b0001;  // Falling Right

    reg [3:0] state;

    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= WL;
        end
        else begin
            case (state)
                WL: begin
                    if (!ground) begin
                        state <= FL;
                    end
                    else if (bump_left) begin
                        state <= WR;
                    end
                end
                WR: begin
                    if (!ground) begin
                        state <= FR;
                    end
                    else if (bump_right) begin
                        state <= WL;
                    end
                end
                FL: begin
                    if (ground) begin
                        state <= WL;
                    end
                end
                FR: begin
                    if (ground) begin
                        state <= WR;
                    end
                end
                default: state <= WL;
            endcase
        end
    end

    assign walk_left = (state == WL);
    assign walk_right = (state == WR);
    assign aaah = (state == FL) || (state == FR);

endmodule