module TopModule(
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    output walk_left,
    output walk_right
);

    reg [1:0] state;
    reg [1:0] next_state;

    // Define the states
    localparam IDLE_LEFT = 2'b01;
    localparam IDLE_RIGHT = 2'b10;

    // Asynchronous reset
    always @(posedge areset or negedge clk) begin
        if(areset) begin
            state <= IDLE_LEFT;
        end else if(clk) begin
            state <= next_state;
        end
    end

    // State machine logic
    always @(state or bump_left or bump_right) begin
        case(state)
            IDLE_LEFT: begin
                if(bump_left) begin
                    next_state = IDLE_RIGHT;
                end else if(bump_right) begin
                    next_state = IDLE_RIGHT;
                end else begin
                    next_state = IDLE_LEFT;
                end
            end
            IDLE_RIGHT: begin
                if(bump_right) begin
                    next_state = IDLE_LEFT;
                end else if(bump_left) begin
                    next_state = IDLE_LEFT;
                end else begin
                    next_state = IDLE_RIGHT;
                end
            end
            default: begin
                next_state = IDLE_LEFT;
            end
        endcase
    end

    // Output logic
    assign walk_left = (state == IDLE_LEFT) ? 1'b1 : 1'b0;
    assign walk_right = (state == IDLE_RIGHT) ? 1'b1 : 1'b0;

endmodule