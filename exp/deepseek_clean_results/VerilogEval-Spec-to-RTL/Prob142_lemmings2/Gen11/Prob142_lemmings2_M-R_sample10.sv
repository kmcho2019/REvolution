module TopModule (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    output reg walk_left,
    output reg walk_right,
    output reg aaah
);

    // State encoding
    parameter WALK = 1'b0;
    parameter FALL = 1'b1;
    
    reg state;      // WALK or FALL
    reg direction;  // 0=left, 1=right

    // State transition logic
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= WALK;
        end
        else begin
            case (state)
                WALK: state <= (ground) ? state : FALL;
                FALL: state <= (ground) ? WALK : FALL;
            endcase
        end
    end

    // Direction update logic
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            direction <= 1'b0;  // Start walking left
        end
        else if (state == WALK && ground) begin
            // Toggle direction when bumped on current walking side
            if ((!direction && bump_left) || (direction && bump_right)) begin
                direction <= ~direction;
            end
        end
    end

    // Output logic (registered Moore outputs)
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            walk_left <= 1'b1;
            walk_right <= 1'b0;
            aaah <= 1'b0;
        end
        else begin
            case (state)
                WALK: begin
                    walk_left <= ~direction;
                    walk_right <= direction;
                    aaah <= 1'b0;
                end
                FALL: begin
                    walk_left <= 1'b0;
                    walk_right <= 1'b0;
                    aaah <= 1'b1;
                end
            endcase
        end
    end

endmodule