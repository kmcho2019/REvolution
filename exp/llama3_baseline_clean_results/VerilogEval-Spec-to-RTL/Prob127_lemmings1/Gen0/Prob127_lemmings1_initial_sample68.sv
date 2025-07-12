module TopModule (
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    output walk_left,
    output walk_right
);

reg [1:0] state; // internal state signal
reg [1:0] next_state; // next state signal

// Define the states
localparam WALK_LEFT = 0;
localparam WALK_RIGHT = 1;

// Sequential logic to update the state
always @(posedge clk or posedge areset) begin
    if (areset) begin // Asynchronous reset
        state <= WALK_LEFT;
    end else begin
        state <= next_state;
    end
end

// Combinational logic to determine the next state
always @(*) begin
    case (state)
        WALK_LEFT: begin
            if (bump_left) begin
                next_state <= WALK_RIGHT;
            end else if (bump_right) begin
                next_state <= WALK_LEFT; // No change
            end else begin
                next_state <= WALK_LEFT; // No change
            end
        end
        WALK_RIGHT: begin
            if (bump_right) begin
                next_state <= WALK_LEFT;
            end else if (bump_left) begin
                next_state <= WALK_RIGHT; // No change
            end else begin
                next_state <= WALK_RIGHT; // No change
            end
        end
    endcase
end

// Output logic
always @(*) begin
    case (state)
        WALK_LEFT: begin
            walk_left <= 1;
            walk_right <= 0;
        end
        WALK_RIGHT: begin
            walk_left <= 0;
            walk_right <= 1;
        end
    endcase
end

endmodule