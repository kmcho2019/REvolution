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

    // One-hot encoded states
    parameter WALK = 3'b001;
    parameter FALL = 3'b010;
    parameter DIG  = 3'b100;
    
    reg [2:0] state;
    reg direction;  // 0=left, 1=right
    reg dig_status; // Active when digging

    // Pre-compute bump conditions
    wire bump_left_active = bump_left && !bump_right;
    wire bump_right_active = bump_right && !bump_left;
    wire bump_both_active = bump_left && bump_right;

    // State update with optimized priority handling
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= WALK;
            dig_status <= 1'b0;
        end else begin
            case (state)
                WALK: begin
                    if (!ground) begin
                        state <= FALL;
                        dig_status <= 1'b0;
                    end else if (dig && !dig_status) begin
                        dig_status <= 1'b1;
                    end else if (dig_status && !ground) begin
                        state <= FALL;
                        dig_status <= 1'b0;
                    end
                end
                
                FALL: if (ground) state <= WALK;
                
                DIG: if (!ground) begin
                    state <= FALL;
                    dig_status <= 1'b0;
                end
            endcase
        end
    end

    // Direction update with clock gating
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            direction <= 1'b0;
        end else if (state == WALK && ground && !dig_status) begin
            if (bump_left_active)
                direction <= 1'b1;
            else if (bump_right_active)
                direction <= 1'b0;
            else if (bump_both_active)
                direction <= ~direction;
        end
    end

    // Output logic with shared resources
    wire walking = (state == WALK) && !dig_status;
    assign walk_left  = walking && !direction;
    assign walk_right = walking && direction;
    assign aaah       = (state == FALL);
    assign digging    = dig_status;

endmodule