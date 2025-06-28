module TopModule (
  input clk,
  input areset,
  input bump_left,
  input bump_right,
  input ground,
  input dig,
  output reg walk_left,
  output reg walk_right,
  output reg aaah,
  output reg digging
);

reg [2:0] counter = 3'd0;
reg previous_ground;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        counter <= 3'd0;
        previous_ground <= 1'b1;
    end else begin
        previous_ground <= ground;
        case (counter)
            3'd0: begin // Default state - walking left
                walk_left = 1;
                walk_right = 0;
                aaah = ground ? 0 : 1;
                digging = 0;
                
                if (bump_right) counter <= 3'd1;
                else if (!ground) counter <= 3'd2;
                else if (dig && ground) counter <= 3'd4;
            end
            3'd1: begin // Bumped on the right
                walk_left = 0;
                walk_right = 1;
                aaah = ground ? 0 : 1;
                digging = 0;
                
                if (bump_left) counter <= 3'd0;
                else if (!ground) counter <= 3'd2;
                else if (dig && ground) counter <= 3'd4;
            end
            3'd2: begin // Falling
                walk_left = previous_ground ? 1 : 0;
                walk_right = previous_ground ? 0 : 1;
                aaah = 1;
                digging = 0;
                
                if (ground) counter <= 3'd0;
                else counter <= 3'd2;
            end
            3'd4: begin // Digging
                walk_left = previous_ground ? 1 : 0;
                walk_right = previous_ground ? 0 : 1;
                aaah = ground ? 0 : 1;
                digging = 1;
                
                if (!ground) counter <= 3'd2;
                else counter <= 3'd4;
            end
        endcase
    end
end

endmodule