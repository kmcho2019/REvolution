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

    // State encoding with direction and action
    localparam [2:0]
        WL = 3'b000,  // Walk left
        WR = 3'b001,  // Walk right
        FL = 3'b010,  // Fall left
        FR = 3'b011,  // Fall right
        DL = 3'b100,  // Dig left
        DR = 3'b101,  // Dig right
        SPLAT = 3'b110; // Splat

    reg [2:0] state, next_state;
    reg [4:0] fall_counter;

    // State transitions
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= WL;
            fall_counter <= 0;
        end else begin
            state <= next_state;
            
            // Update fall counter
            if (state == FL || state == FR) begin
                if (~ground) fall_counter <= fall_counter + 1;
            end else begin
                fall_counter <= 0;
            end
        end
    end

    // Next state logic with strict priority
    always @(*) begin
        case (state)
            WL, WR: begin
                if (~ground) begin
                    next_state = (state == WL) ? FL : FR;
                end else if (dig) begin
                    next_state = (state == WL) ? DL : DR;
                end else if ((state == WL && bump_left) || 
                           (state == WR && bump_right)) begin
                    next_state = (state == WL) ? WR : WL;
                end else begin
                    next_state = state;
                end
            end
            
            FL, FR: begin
                if (ground) begin
                    next_state = (fall_counter > 20) ? SPLAT : 
                                 ((state == FL) ? WL : WR);
                end else begin
                    next_state = state;
                end
            end
            
            DL, DR: begin
                if (~ground) begin
                    next_state = (state == DL) ? FL : FR;
                end else begin
                    next_state = state;
                end
            end
            
            SPLAT: next_state = SPLAT;
            
            default: next_state = WL;
        endcase
    end

    // Output logic - pure combinatorial
    assign walk_left = (state == WL);
    assign walk_right = (state == WR);
    assign aaah = (state == FL || state == FR);
    assign digging = (state == DL || state == DR);

endmodule