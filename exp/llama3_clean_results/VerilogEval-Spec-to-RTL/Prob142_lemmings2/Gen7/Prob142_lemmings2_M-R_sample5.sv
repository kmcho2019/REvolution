module TopModule(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    output reg walk_left,
    output reg walk_right,
    output reg aaah
);

// State encoding: 2'b00 - walking left, 2'b01 - walking right, 2'b10 - falling left, 2'b11 - falling right
reg [1:0] state;

// Sequential logic to update the state
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b00; // reset to walking left
    end else begin
        case(state)
            2'b00: // walking left
                begin
                    if (~ground) state <= 2'b10; // start falling left
                    else if (bump_left) state <= 2'b01; // switch to walking right
                    else if (bump_right) state <= 2'b01; // switch to walking right
                end
            2'b01: // walking right
                begin
                    if (~ground) state <= 2'b11; // start falling right
                    else if (bump_right) state <= 2'b00; // switch to walking left
                    else if (bump_left) state <= 2'b00; // switch to walking left
                end
            2'b10, 2'b11: // falling
                begin
                    if (ground) // ground reappeared
                        begin
                            // Resume walking in the same direction as before the fall
                            if (state == 2'b10) state <= 2'b00; // resume walking left
                            else state <= 2'b01; // resume walking right
                        end
                end
        endcase
    end
end

// Output logic using assign statements
assign walk_left = (state == 2'b00 || state == 2'b10)? 1'b1 : 1'b0;
assign walk_right = (state == 2'b01 || state == 2'b11)? 1'b1 : 1'b0;
assign aaah = (state == 2'b10 || state == 2'b11)? 1'b1 : 1'b0;

endmodule