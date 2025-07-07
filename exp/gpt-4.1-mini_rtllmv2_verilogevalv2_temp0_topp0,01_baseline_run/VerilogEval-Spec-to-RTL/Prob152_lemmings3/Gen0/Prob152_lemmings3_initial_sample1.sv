module TopModule(
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

// State encoding
localparam [1:0]
    WLK = 2'b00, // walking left
    WRG = 2'b01, // walking right
    FALL= 2'b10, // falling (aaah)
    DIGG= 2'b11; // digging

reg [1:0] state, next_state;

// On asynchronous reset or clock edge, update state
always @(posedge clk or posedge areset) begin
    if (areset)
        state <= WLK;
    else
        state <= next_state;
end

// Next state logic (Moore FSM)
always @(*) begin
    // Default next state is current state
    next_state = state;

    case(state)
        WLK: begin
            // Priority: fall > dig > bump
            if (!ground)
                next_state = FALL;
            else if (dig)
                next_state = DIGG;
            else if (bump_left || bump_right)
                next_state = WRG;
            else
                next_state = WLK;
        end
        WRG: begin
            if (!ground)
                next_state = FALL;
            else if (dig)
                next_state = DIGG;
            else if (bump_left || bump_right)
                next_state = WLK;
            else
                next_state = WRG;
        end
        FALL: begin
            // Falling continues while ground=0
            // When ground=1, resume walking in previous direction
            if (ground) begin
                // Resume walking in previous direction
                // We must remember direction before falling
                // But since state is FALL, we lost direction info
                // So we store direction in a separate reg
                // We'll handle this below
                // For now, next_state assigned in sequential block
                // So here just keep FALL
                next_state = FALL;
            end else begin
                next_state = FALL;
            end
        end
        DIGG: begin
            // Digging continues while ground=1
            // When ground=0, fall
            if (!ground)
                next_state = FALL;
            else
                next_state = DIGG;
        end
        default: next_state = WLK;
    endcase
end

// To remember walking direction before falling, we use a reg
// walking_dir: 0 = left, 1 = right
reg walking_dir;

// Update walking_dir on walking states and on reset
always @(posedge clk or posedge areset) begin
    if (areset) begin
        walking_dir <= 1'b0; // left
    end else begin
        case(next_state)
            WLK: walking_dir <= 1'b0;
            WRG: walking_dir <= 1'b1;
            FALL: ; // keep walking_dir unchanged
            DIGG: ; // keep walking_dir unchanged
            default: walking_dir <= walking_dir;
        endcase
    end
end

// Now fix FALL state transition to resume walking in walking_dir when ground=1
always @(*) begin
    if (state == FALL && ground) begin
        if (walking_dir == 1'b0)
            next_state = WLK;
        else
            next_state = WRG;
    end
end

// Output logic (Moore)
always @(*) begin
    walk_left = 1'b0;
    walk_right = 1'b0;
    aaah = 1'b0;
    digging = 1'b0;

    case(state)
        WLK: walk_left = 1'b1;
        WRG: walk_right = 1'b1;
        FALL: aaah = 1'b1;
        DIGG: digging = 1'b1;
    endcase
end

endmodule