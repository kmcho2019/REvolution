module TopModule(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    output walk_left,
    output walk_right,
    output aaah
);

reg [1:0] state;

always @(posedge clk or posedge areset) begin
    if (areset == 1'b1) begin
        state <= 2'b00; // reset to Walking Left
    end else begin
        case(state)
            2'b00: begin // Walking Left
                if (ground == 1'b0) begin
                    state <= 2'b10; // transition to Falling
                end else if (bump_right == 1'b1) begin
                    state <= 2'b01; // switch to Walking Right
                end
            end
            2'b01: begin // Walking Right
                if (ground == 1'b0) begin
                    state <= 2'b10; // transition to Falling
                end else if (bump_left == 1'b1) begin
                    state <= 2'b00; // switch to Walking Left
                end
            end
            2'b10: begin // Falling
                if (ground == 1'b1) begin
                    if (bump_left == 1'b1 && bump_right == 1'b1) begin
                        // if both bump_left and bump_right are high, 
                        // the direction should still switch
                        state <= (state == 2'b00)? 2'b01 : 2'b00;
                    end else if (bump_left == 1'b1) begin
                        state <= 2'b01; // resume Walking Right
                    end else if (bump_right == 1'b1) begin
                        state <= 2'b00; // resume Walking Left
                    end else begin
                        // if neither bump_left nor bump_right are high,
                        // the Lemming should resume its original direction
                        state <= (state == 2'b00)? 2'b00 : 2'b01;
                    end
                end
            end
        endcase
    end
end

assign walk_left = (state == 2'b00)? 1'b1 : 1'b0;
assign walk_right = (state == 2'b01)? 1'b1 : 1'b0;
assign aaah = (state == 2'b10)? 1'b1 : 1'b0;

endmodule