module TopModule(
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

localparam WL = 2'd0, // walk left
           WR = 2'd1, // walk right
           FL = 2'd2, // fall (direction left)
           FR = 2'd3; // fall (direction right)

reg [1:0] state;

always @(posedge clk or posedge areset) begin
    if (areset)
        state <= WL;
    else begin
        case(state)
            WL: begin
                if (!ground)
                    state <= FL;
                else if (dig)
                    state <= WL + 2; // dig left encoded as FL (2)
                else if (bump_left || bump_right) begin
                    // change direction to right
                    state <= WR;
                end
            end
            WR: begin
                if (!ground)
                    state <= FR;
                else if (dig)
                    state <= WR + 2; // dig right encoded as FR (3)
                else if (bump_left || bump_right) begin
                    // change direction to left
                    state <= WL;
                end
            end
            FL: begin // dig or fall left
                if (ground)
                    state <= WL;
            end
            FR: begin // dig or fall right
                if (ground)
                    state <= WR;
            end
        endcase
    end
end

assign walk_left  = (state == WL);
assign walk_right = (state == WR);
assign aaah       = (state == FL) || (state == FR);
assign digging    = (state == FL) || (state == FR) && (ground == 1'b0 ? 1'b0 : 1'b1) ? 1'b1 : 1'b0;

// To differentiate digging and falling, note that states 2 and 3 represent both fall and dig, so fix this:
wire is_fall = (state == FL) || (state == FR);
wire is_dig = ((state == WL + 2) || (state == WR + 2)); // but WL+2=2, WR+2=3 same as fall

// Actually, this encoding mixes dig and fall in the same states 2 and 3, which loses info
// So need to store dig as separate flag

// Let's refine with a dig flag:

reg dig_flag;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        dig_flag <= 1'b0;
    end else begin
        case (state)
            WL, WR: begin
                if (!ground)
                    dig_flag <= 1'b0;
                else if (dig)
                    dig_flag <= 1'b1;
                else if (bump_left || bump_right)
                    dig_flag <= 1'b0;
            end
            FL, FR: begin
                if (ground)
                    dig_flag <= 1'b0;
            end
            default: dig_flag <= 1'b0;
        endcase
    end
end

// redefine aaah = !ground and not walking (either falling or digging and ground=0)
assign aaah = (state == FL || state == FR) && !ground;
assign digging = dig_flag && ground;

endmodule