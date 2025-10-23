module TopModule(
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    input  ground,
    input  dig,
    output walk_left,
    output walk_right,
    output aaah,
    output digging
);

// Enumerate states
parameter WL = 3'b000; // Walking Left
parameter WR = 3'b001; // Walking Right
parameter FL = 3'b010; // Falling Left
parameter FR = 3'b011; // Falling Right
parameter DL = 3'b100; // Digging Left
parameter DR = 3'b101; // Digging Right

reg [2:0] current_state;
reg [2:0] next_state;

// Outputs based on current state
assign walk_left = (current_state == WL || current_state == FL);
assign walk_right = (current_state == WR || current_state == FR);
assign aaah = (current_state == FL || current_state == FR);
assign digging = (current_state == DL || current_state == DR);

// Sequential logic
always @(posedge clk or posedge areset) begin
    if (areset) begin
        current_state <= WL;
    end else begin
        current_state <= next_state;
    end
end

// Combinational logic for next state
always @(*) begin
    case (current_state)
        WL: begin
            if (!ground) begin
                next_state = FL;
            end else if (dig) begin
                next_state = DL;
            end else if (bump_left) begin
                next_state = WR;
            end else if (bump_right) begin
                next_state = WL;
            end else begin
                next_state = WL;
            end
        end
        WR: begin
            if (!ground) begin
                next_state = FR;
            end else if (dig) begin
                next_state = DR;
            end else if (bump_right) begin
                next_state = WL;
            end else if (bump_left) begin
                next_state = WR;
            end else begin
                next_state = WR;
            end
        end
        FL, FR: begin
            if (ground) begin
                if (current_state == FL) begin
                    next_state = WL;
                end else begin
                    next_state = WR;
                end
            end else begin
                next_state = current_state;
            end
        end
        DL: begin
            if (!ground) begin
                next_state = FL;
            end else begin
                next_state = DL;
            end
        end
        DR: begin
            if (!ground) begin
                next_state = FR;
            end else begin
                next_state = DR;
            end
        end
        default: next_state = WL;
    endcase
end

endmodule