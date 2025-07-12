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

    // State encoding with Gray code for low power
    parameter [2:0] WALK_L = 3'b000,
                    WALK_R = 3'b001,
                    FALL   = 3'b011,
                    DIG    = 3'b010;

    reg [2:0] state, next_state;

    // State transition logic with optimized priority handling
    always @(*) begin
        case (state[2:1])
            2'b00: begin // WALK states
                if (!ground) begin
                    next_state = FALL;
                end else if (dig) begin
                    next_state = DIG;
                end else begin
                    // Handle direction changes
                    if ((bump_left && state[0] == 1'b0) || 
                        (bump_right && state[0] == 1'b1)) begin
                        next_state = {state[2:1], ~state[0]}; // Toggle direction
                    end else begin
                        next_state = state;
                    end
                end
            end
            
            2'b01: begin // FALL state
                if (ground) begin
                    next_state = {1'b0, state[0]}; // Return to WALK with same direction
                end else begin
                    next_state = state;
                end
            end
            
            2'b01: begin // DIG state
                if (!ground) begin
                    next_state = FALL;
                end else begin
                    next_state = state;
                end
            end
            
            default: next_state = WALK_L;
        endcase
    end

    // State register with async reset
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= WALK_L;
        end else begin
            state <= next_state;
        end
    end

    // Output logic - optimized with shared decoding
    assign walk_left = (state[2:1] == 2'b00) & ~state[0];
    assign walk_right = (state[2:1] == 2'b00) & state[0];
    assign aaah = (state[2:1] == 2'b01);
    assign digging = (state[2:1] == 2'b01);

endmodule