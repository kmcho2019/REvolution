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

    parameter WL = 3'b000;  // Walk Left
    parameter WR = 3'b001;  // Walk Right
    parameter DL = 3'b010;  // Dig Left
    parameter DR = 3'b011;  // Dig Right
    parameter FL = 3'b100;  // Fall Left
    parameter FR = 3'b101;  // Fall Right
    parameter SPLAT = 3'b111; // Dead

    reg [2:0] state;
    reg [4:0] fall_timer;

    // State transition logic
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= WL;
            fall_timer <= 0;
        end else begin
            case (state)
                WL, WR: begin
                    if (!ground) begin
                        state <= (state == WL) ? FL : FR;
                        fall_timer <= 0;
                    end else if (dig) begin
                        state <= (state == WL) ? DL : DR;
                    end else if ((state == WL && bump_left) || (state == WR && bump_right)) begin
                        state <= (state == WL) ? WR : WL;
                    end
                end

                DL, DR: begin
                    if (!ground) begin
                        state <= (state == DL) ? FL : FR;
                        fall_timer <= 0;
                    end else if (!dig) begin
                        state <= (state == DL) ? WL : WR;
                    end
                end

                FL, FR: begin
                    fall_timer <= fall_timer + 1;
                    if (ground) begin
                        if (fall_timer > 20)
                            state <= SPLAT;
                        else
                            state <= (state == FL) ? WL : WR;
                    end
                end

                SPLAT: state <= SPLAT;
            endcase
        end
    end

    // Output logic
    assign walk_left = (state == WL);
    assign walk_right = (state == WR);
    assign aaah = (state == FL || state == FR);
    assign digging = (state == DL || state == DR);

endmodule