module TopModule (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    input dig,
    output walk_left,
    output walk_right,
    output aaah,
    output digging
);

    // State encoding
    reg [1:0] state;
    parameter WL = 2'b00,  // Walking left
              WR = 2'b01,  // Walking right
              FL = 2'b10,  // Falling
              DG = 2'b11;  // Digging

    // Next state logic
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= WL;
        end else begin
            case (state)
                WL, WR: begin
                    if (~ground) begin
                        state <= FL;
                    end else if (dig) begin
                        state <= DG;
                    end else if (state == WL && bump_left) begin
                        state <= WR;
                    end else if (state == WR && bump_right) begin
                        state <= WL;
                    end
                end
                FL: begin
                    if (ground) begin
                        state <= (state == FL) ? WL : state;  // Return to previous direction
                    end
                end
                DG: begin
                    if (~ground) begin
                        state <= FL;
                    end
                end
            endcase
        end
    end

    // Output logic
    assign walk_left = (state == WL);
    assign walk_right = (state == WR);
    assign aaah = (state == FL);
    assign digging = (state == DG);

endmodule