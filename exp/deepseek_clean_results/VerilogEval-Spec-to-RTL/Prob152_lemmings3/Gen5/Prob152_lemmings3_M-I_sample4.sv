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

    // One-hot state encoding
    parameter WALK = 3'b001;
    parameter FALL = 3'b010;
    parameter DIG  = 3'b100;

    reg [2:0] state;
    reg direction; // 0=left, 1=right
    reg bump_left_sync, bump_right_sync;
    reg ground_sync;

    // Input synchronization
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            bump_left_sync <= 0;
            bump_right_sync <= 0;
            ground_sync <= 1;
        end else begin
            bump_left_sync <= bump_left;
            bump_right_sync <= bump_right;
            ground_sync <= ground;
        end
    end

    // State transitions
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALK;
        end
        else case (1'b1)
            state[0]: // WALK
                if (!ground_sync) begin
                    state <= FALL;
                end
                else if (dig) begin
                    state <= DIG;
                end
            
            state[1]: // FALL
                if (ground_sync) begin
                    state <= WALK;
                end
            
            state[2]: // DIG
                if (!ground_sync) begin
                    state <= FALL;
                end
        endcase
    end

    // Direction logic (separate for timing)
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            direction <= 0;
        end
        else if (state[0]) begin // Only change direction in WALK state
            case ({bump_left_sync, bump_right_sync})
                2'b10: direction <= 1; // Switch to right
                2'b01: direction <= 0; // Switch to left
                default: ; // Maintain direction
            endcase
        end
    end

    // Output logic (simplified with one-hot)
    assign walk_left = state[0] & ~direction;
    assign walk_right = state[0] & direction;
    assign aaah = state[1];
    assign digging = state[2];

endmodule