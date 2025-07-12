module TopModule(
    input  wire clk,
    input  wire areset,
    input  wire bump_left,
    input  wire bump_right,
    input  wire ground,
    output wire walk_left,
    output wire walk_right,
    output wire aaah
);

    // State encoding (2 bits):
    // bit1: falling (1) or walking (0)
    // bit0: direction (0=left, 1=right)
    localparam WALK_LEFT  = 2'b00;
    localparam WALK_RIGHT = 2'b01;
    localparam FALL_LEFT  = 2'b10;
    localparam FALL_RIGHT = 2'b11;

    reg [1:0] state, next_state;

    wire bump = bump_left | bump_right;

    always @(*) begin
        next_state = state;  // default

        if (state[1] == 1'b0) begin // walking
            if (ground == 1'b0) begin
                next_state = {1'b1, state[0]}; // start falling, preserve direction
            end else if (bump) begin
                // Flip direction if bumped (either side or both)
                next_state = {1'b0, ~state[0]};
            end else begin
                next_state = state;
            end
        end else begin // falling
            if (ground == 1'b1) begin
                next_state = {1'b0, state[0]}; // stop falling, keep direction
            end else begin
                next_state = state;
            end
        end
    end

    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= WALK_LEFT;
        else
            state <= next_state;
    end

    assign aaah       = state[1];          // falling bit
    assign walk_left  = ~state[1] & ~state[0];
    assign walk_right = ~state[1] &  state[0];

endmodule