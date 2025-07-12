module TopModule(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output walk_left,
    output walk_right
);

    // Define the states
    reg [1:0] state; // 0: walking left, 1: walking right
    parameter IDLE_LEFT = 2'b00, IDLE_RIGHT = 2'b01;

    // Sequential logic: state register
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= IDLE_LEFT;
        end else begin
            if (bump_left && bump_right) begin
                // if both bumps, switch direction
                if (state == IDLE_LEFT) begin
                    state <= IDLE_RIGHT;
                end else begin
                    state <= IDLE_LEFT;
                end
            end else if (bump_left) begin
                state <= IDLE_RIGHT;
            end else if (bump_right) begin
                state <= IDLE_LEFT;
            end
        end
    end

    // Combinational logic: output
    always @(state) begin
        case (state)
            IDLE_LEFT: begin
                walk_left <= 1'b1;
                walk_right <= 1'b0;
            end
            IDLE_RIGHT: begin
                walk_left <= 1'b0;
                walk_right <= 1'b1;
            end
            default: begin
                walk_left <= 1'b0;
                walk_right <= 1'b0;
            end
        endcase
    end

endmodule